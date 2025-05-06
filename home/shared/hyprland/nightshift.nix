{ config, pkgs, ... }:
let
  username = config.home.username;
  latitude = "48.85E";
  longitude = "9.486W"; # Weird offset
in
{
  home.packages = with pkgs; [
    hyprshade
    sunwait
  ];

  home.file.".config/hypr/shaders/blue-light.glsl".text = ''
      // from https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437

    precision highp float;
    varying vec2 v_texcoord;
    uniform sampler2D tex;

    const float temperature = 2600.0;
    const float temperatureStrength = 0.6;

    #define WithQuickAndDirtyLuminancePreservation
    const float LuminancePreservationFactor = 1.0;

    // function from https://www.shadertoy.com/view/4sc3D7
    // valid from 1000 to 40000 K (and additionally 0 for pure full white)
    vec3 colorTemperatureToRGB(const in float temperature) {
        // values from: http://blenderartists.org/forum/showthread.php?270332-OSL-Goodness&p=2268693&viewfull=1#post2268693
        mat3 m = (temperature <= 6500.0) ? mat3(vec3(0.0, -2902.1955373783176, -8257.7997278925690),
                                                vec3(0.0, 1669.5803561666639, 2575.2827530017594),
                                                vec3(1.0, 1.3302673723350029, 1.8993753891711275))
                                         : mat3(vec3(1745.0425298314172, 1216.6168361476490, -8257.7997278925690),
                                                vec3(-2666.3474220535695, -2173.1012343082230, 2575.2827530017594),
                                                vec3(0.55995389139931482, 0.70381203140554553, 1.8993753891711275));
        return mix(clamp(vec3(m[0] / (vec3(clamp(temperature, 1000.0, 40000.0)) + m[1]) + m[2]), vec3(0.0), vec3(1.0)),
                   vec3(1.0), smoothstep(1000.0, 0.0, temperature));
    }

    void main() {
        vec4 pixColor = texture2D(tex, v_texcoord);

        // RGB
        vec3 color = vec3(pixColor[0], pixColor[1], pixColor[2]);

    #ifdef WithQuickAndDirtyLuminancePreservation
        color *= mix(1.0, dot(color, vec3(0.2126, 0.7152, 0.0722)) / max(dot(color, vec3(0.2126, 0.7152, 0.0722)), 1e-5),
                     LuminancePreservationFactor);
    #endif

        color = mix(color, color * colorTemperatureToRGB(temperature), temperatureStrength);

        vec4 outCol = vec4(color, pixColor[3]);

        gl_FragColor = outCol;
    }
  '';
  home.file.".config/hypr/shaders/blue-light-transition.glsl".text = ''
      // from https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437

    precision highp float;
    varying vec2 v_texcoord;
    uniform sampler2D tex;

    const float temperature = 4600.0;
    const float temperatureStrength = 0.3;

    #define WithQuickAndDirtyLuminancePreservation
    const float LuminancePreservationFactor = 1.0;

    // function from https://www.shadertoy.com/view/4sc3D7
    // valid from 1000 to 40000 K (and additionally 0 for pure full white)
    vec3 colorTemperatureToRGB(const in float temperature) {
        // values from: http://blenderartists.org/forum/showthread.php?270332-OSL-Goodness&p=2268693&viewfull=1#post2268693
        mat3 m = (temperature <= 6500.0) ? mat3(vec3(0.0, -2902.1955373783176, -8257.7997278925690),
                                                vec3(0.0, 1669.5803561666639, 2575.2827530017594),
                                                vec3(1.0, 1.3302673723350029, 1.8993753891711275))
                                         : mat3(vec3(1745.0425298314172, 1216.6168361476490, -8257.7997278925690),
                                                vec3(-2666.3474220535695, -2173.1012343082230, 2575.2827530017594),
                                                vec3(0.55995389139931482, 0.70381203140554553, 1.8993753891711275));
        return mix(clamp(vec3(m[0] / (vec3(clamp(temperature, 1000.0, 40000.0)) + m[1]) + m[2]), vec3(0.0), vec3(1.0)),
                   vec3(1.0), smoothstep(1000.0, 0.0, temperature));
    }

    void main() {
        vec4 pixColor = texture2D(tex, v_texcoord);

        // RGB
        vec3 color = vec3(pixColor[0], pixColor[1], pixColor[2]);

    #ifdef WithQuickAndDirtyLuminancePreservation
        color *= mix(1.0, dot(color, vec3(0.2126, 0.7152, 0.0722)) / max(dot(color, vec3(0.2126, 0.7152, 0.0722)), 1e-5),
                     LuminancePreservationFactor);
    #endif

        color = mix(color, color * colorTemperatureToRGB(temperature), temperatureStrength);

        vec4 outCol = vec4(color, pixColor[3]);

        gl_FragColor = outCol;
    }
  '';
  systemd.user.timers."nightshift" = {
    Install = {
      WantedBy = [ "timers.target" ];
    };
    Unit = {
      After = [ "graphical-session.target" ];
    };
    Timer = {
      OnBootSec = "0s";
      OnCalendar = "*:0/10";
      Unit = "nightshift.service";
    };
  };

  systemd.user.services."nightshift" = {
    Unit = {
      Description = "Automatically change brightness and color scheme.";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "transition-shift" ''
                inf_30=$(${pkgs.sunwait}/bin/sunwait poll angle 30 ${latitude} ${longitude})
                inf_12=$(${pkgs.sunwait}/bin/sunwait poll angle 12 ${latitude} ${longitude})
                inf_0=$(${pkgs.sunwait}/bin/sunwait poll angle 0 ${latitude} ${longitude})
                echo "inf30: "$inf_30
                echo "inf12: "$inf_12
                echo "inf0: "$inf_0
                b=0
                if [ $inf_30 == DAY ]; then
                    b=80
                    ${pkgs.hyprshade}/bin/hyprshade on vibrance
                elif [ $inf_12 == DAY ]; then
                    b=60
                    ${pkgs.hyprshade}/bin/hyprshade on vibrance
                elif [ $inf_0 == NIGHT ]; then
                    b=20
                    ${pkgs.hyprshade}/bin/hyprshade on blue-light
                else
                    ${pkgs.hyprshade}/bin/hyprshade on blue-light-transition
                    inf_9=$(${pkgs.sunwait}/bin/sunwait poll angle 9 ${latitude} ${longitude})
                    inf_6=$(${pkgs.sunwait}/bin/sunwait poll angle 6 ${latitude} ${longitude})
                    inf_3=$(${pkgs.sunwait}/bin/sunwait poll angle 3 ${latitude} ${longitude})
                    echo "inf9: "$inf_9
                    echo "inf6: "$inf_6
                    echo "inf3: "$inf_3
                    if [ $inf_9 == DAY ]; then
                        b=50
                    elif [ $inf_6 == DAY ]; then
                        b=40
                    elif [ $inf_3 == DAY ]; then
                        b=30
                    else
                        b=20
                    fi
                fi
        	if [ $(date +%H) -lt 14 ]; then
        	  b=$((b - 20))
                fi
                echo "Used b: "$b
                ${pkgs.ddcutil}/bin/ddcutil detect | grep I2C | cut -d"/" -f3 | cut -d"-" -f2 | while read -r nb; do
                    ${pkgs.ddcutil}/bin/ddcutil -b $nb setvcp 10 $b || continue
                done
      ''}";
    };
  };
}
