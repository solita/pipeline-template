#!/bin/bash
set -eu

script_dir="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
sample_dir="$script_dir/samples"

function list_available_samples {
  echo "Available samples:" >&2
  for s in $(ls "$sample_dir"); do
    echo "  - $s: $(cat "$sample_dir/$s/.description")"
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
  if [[ ! -d "$sample_dir/$sample" ]]; then
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

cp -ir "$script_dir/skel/"* "$script_dir/skel/.util" "$project_dir"
cp -ir "$sample_dir/$sample/"* "$project_dir"

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
