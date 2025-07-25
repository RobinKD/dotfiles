{ config, pkgs, ... }:
let
  username = config.home.username;
  latitude = "48.85E";
  longitude = "4.486W";
in
{
  home.packages = with pkgs; [
    hyprshade
    sunwait
  ];

  home.file.".config/hypr/shaders/blue-light.glsl".text = ''
    // from https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437

    #version 300 es

    precision highp float;
    in vec2 v_texcoord;
    uniform sampler2D tex;
    out vec4 fragColor;

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

        fragColor = outCol;
    }
  '';
  home.file.".config/hypr/shaders/blue-light-transition.glsl".text = ''
    // from https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437

    #version 300 es

    precision highp float;
    in vec2 v_texcoord;
    uniform sampler2D tex;
    out vec4 fragColor;

    const float temperature = 4600.0;
    const float temperatureStrength = 0.5;

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

        fragColor = outCol;
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
      OnBootSec = "30s";
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
      ExecStart =
        let
          python = pkgs.python3.withPackages (ps: with ps; [ numpy ]);
        in
        "${python.interpreter} ${pkgs.writeScript "transition-shift.py" ''
          import subprocess
          from datetime import datetime, date, timedelta
          import numpy as np

          proc = subprocess.Popen(
            "${pkgs.sunwait}/bin/sunwait list angle -10 ${latitude} ${longitude}",
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
          )
          try:
            outs, errs = proc.communicate(timeout=15)
          except TimeoutExpired:
            proc.kill()
            outs, errs = proc.communicate()
          print(outs.decode())
          if errs:
            print(errs.decode())

          sunrise = timedelta(hours=int(outs[:2]), minutes=int(outs[3:5]))
          sunset = timedelta(hours=int(outs[7:9]), minutes=int(outs[10:12]))

          day_time = sunset - sunrise
          mid_day = sunrise + day_time / 2

          print(day_time, mid_day)

          now = datetime.now()
          now_delta = timedelta(hours=now.hour, minutes=now.minute)
          print(now_delta)

          def gauss(t):
            res = (t - mid_day).total_seconds() / (day_time.total_seconds() / 12)
            return np.exp(-1 / 12 * (res**2))


          def brightness(t):
            gauss_res = gauss(t)
            # print(t)
            # print(mid_day)
            before_midday = t - mid_day
            # print(before_midday.total_seconds())
            b = int(100 * gauss(t))
            if before_midday.total_seconds() < 0:
              b -= 10
            return max(b, 0)


          b = brightness(now_delta)
          print("Using brightness: ", b)

          proc = subprocess.Popen(
            '${pkgs.ddcutil}/bin/ddcutil detect | grep I2C | cut -d"/" -f3 | cut -d"-" -f2',
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
          )
          try:
            outs, errs = proc.communicate(timeout=15)
          except TimeoutExpired:
            proc.kill()
            outs, errs = proc.communicate()
          if errs:
            print(errs.decode())
                    		      
          if b > 45:
            subprocess.Popen(
              "${pkgs.hyprshade}/bin/hyprshade on vibrance_fix",
              shell=True,
            )
          elif b > 20:
            subprocess.Popen(
              "${pkgs.hyprshade}/bin/hyprshade on blue-light-transition",
              shell=True,
            )
          else:
            subprocess.Popen(
              "${pkgs.hyprshade}/bin/hyprshade on blue-light",
              shell=True,
          )

          bus_numbers = outs.decode().splitlines()
          for bus in bus_numbers:
            proc = subprocess.Popen(
              f"${pkgs.ddcutil}/bin/ddcutil -b {bus} setvcp 10 {b}",
              shell=True,
            )
            try:
               outs, errs = proc.communicate(timeout=15)
            except TimeoutExpired:
               proc.kill()
               outs, errs = proc.communicate()
            if errs:
               print(errs.decode())
        ''}";
    };
  };
}
