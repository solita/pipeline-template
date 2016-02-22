#!/bin/bash
set -eu

script_dir="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"

function samples {
  find "$script_dir" -mindepth 1 -maxdepth 1 -type d -not \( -name common -or -name .git \) -printf '%P\n'
}

function list_available_samples {
  echo "Available samples:" >&2
  for s in $(samples); do
    echo "  - $s: $(cat "$script_dir/$s/.description")"
  done
}

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 NAME DIR [SAMPLE]" >&2
  echo >&2
  echo "SAMPLE defaults to 'empty'." >&2
  echo >&2
  list_available_samples
  exit 1
fi

if [[ $# -gt 2 ]]; then
  sample="$3"
  if [[ ! $(samples) =~ "$sample" ]]; then
    echo "Invalid sample: $sample" >&2
    echo >&2
    list_available_samples
    exit 1
  fi
else
  sample='empty'
fi

project_name="$1"
project_dir="$2"
mkdir -p "$project_dir"
echo "$project_name" > "$project_dir/.project_name"

cp -ir "$script_dir/common/"* "$script_dir/common/.util" "$project_dir"
cp -ir "$script_dir/$sample/"* "$project_dir"

echo "Project $project_name created successfully!"
echo
echo 'Next steps:'
echo
echo ' 1. Change to the project directory:'
echo
echo "        cd $project_dir"
echo
echo ' 2. Start the playground containers:'
echo
echo '        playground/start.sh'
echo
echo " 3. Configure the playground:"
echo
echo '        ./ansible-playbook site.yml'
echo
