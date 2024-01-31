#!/usr/bin/env bash

built_updates_time=$(stat --format="%Z" $HOME/.dotfiles/build_updates)
current_system_latest_time=$(stat --format="%Z" /run/current-system)

if [[ $built_updates_time -lt $current_system_latest_time ]]; then
	nb_updates=0
	updates=""
else
	updates=$(nix store diff-closures /run/current-system $HOME/.dotfiles/build_updates)
	nb_updates=$(echo "$updates" | sed -r '/^\s*$/d' | wc -l)
fi

updates_done=$(nix store diff-closures /run/booted-system /run/current-system)
nb_updates_done=$(echo "$updates_done" | sed -r '/^\s*$/d' | wc -l)

if [ $(($nb_updates + $nb_updates_done)) -eq 0 ]; then
	full_updates=""
elif [ $nb_updates -eq 0 ]; then
	full_updates="${nb_updates_done} updates done since boot:\n$updates_done"
elif [ $nb_updates_done -eq 0 ]; then
	full_updates="$updates"
else
	full_updates="$updates \n${nb_updates_done} updates done since boot:\n$updates_done"
fi

if [ $(($nb_updates + $nb_updates_done)) -gt 30 ]; then
	tooltip="$(echo "$full_updates" | head -n 30 | sed -z 's/\n/\\n/g' | sed -e 's/\x1b\[[0-9;]*m//g')"
	tooltip+='...'
else
	if [ $(($nb_updates + $nb_updates_done)) -eq 0 ]; then
		tooltip=""
	else
		tooltip="$(echo "$full_updates" | sed -z 's/\n/\\n/g' | sed -e 's/\x1b\[[0-9;]*m//g')"
	fi
fi

if [ $nb_updates -eq 1 ]; then
	text="$nb_updates update"
elif [ $nb_updates -eq 0 ]; then
	text="Nothing to do"
else
	text="$nb_updates updates"
fi

# printf '{"text": "%s", "tooltip": "%s"}' $nb_updates $tooltip
echo "{\"text\":\""$text"\", \"tooltip\":\""$tooltip"\"}"
exit 0
