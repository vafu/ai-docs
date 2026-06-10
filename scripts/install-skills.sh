#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$repo_root/skills"
dest_root="${CODEX_HOME:-$HOME/.codex}/skills"
force=0
dry_run=0
list_only=0
skills=()

usage() {
  cat <<'USAGE'
Usage: scripts/install-skills.sh [options] [skill ...]

Install skills from this repository into ${CODEX_HOME:-$HOME/.codex}/skills.
If no skill names are provided, all skills under ./skills are installed.

Options:
  --dest PATH   Install into PATH instead of ${CODEX_HOME:-$HOME/.codex}/skills
  --force       Replace an existing installed skill directory
  --dry-run     Print what would be installed without changing files
  --list        List skills available in this repository
  -h, --help    Show this help

Examples:
  scripts/install-skills.sh
  scripts/install-skills.sh rust-guide
  scripts/install-skills.sh --force rust-guide
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      [[ $# -ge 2 ]] || { echo "--dest requires a path" >&2; exit 2; }
      dest_root="$2"
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --list)
      list_only=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        skills+=("$1")
        shift
      done
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      skills+=("$1")
      shift
      ;;
  esac
done

if [[ ! -d "$skills_dir" ]]; then
  echo "skills directory not found: $skills_dir" >&2
  exit 1
fi

available_skills=()
while IFS= read -r -d '' skill_path; do
  available_skills+=("$(basename "$skill_path")")
done < <(find "$skills_dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [[ "$list_only" -eq 1 ]]; then
  printf '%s\n' "${available_skills[@]}"
  exit 0
fi

if [[ "${#skills[@]}" -eq 0 ]]; then
  skills=("${available_skills[@]}")
fi

if [[ "${#skills[@]}" -eq 0 ]]; then
  echo "no skills found under $skills_dir" >&2
  exit 1
fi

if [[ "$dry_run" -eq 0 ]]; then
  mkdir -p "$dest_root"
fi

for skill in "${skills[@]}"; do
  src="$skills_dir/$skill"
  dest="$dest_root/$skill"

  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "skip: $skill is not a valid skill directory: $src" >&2
    exit 1
  fi

  if [[ -e "$dest" && "$force" -ne 1 ]]; then
    echo "exists: $dest (use --force to replace)" >&2
    exit 1
  fi

  if [[ "$dry_run" -eq 1 ]]; then
    if [[ -e "$dest" && "$force" -eq 1 ]]; then
      echo "would replace $dest from $src"
    else
      echo "would install $skill to $dest"
    fi
    continue
  fi

  if [[ -e "$dest" ]]; then
    rm -rf "$dest"
  fi
  cp -R "$src" "$dest"
  echo "installed $skill -> $dest"
done

cat <<'NOTE'

Restart Codex to pick up newly installed or updated skills.
NOTE
