#!/usr/bin/env sh
set -eu

versioning_die() {
  echo "alfazen-versioning: $*" >&2
  return 1
}

versioning_repo_root() {
  git rev-parse --show-toplevel
}

versioning_path() {
  printf '%s/VERSION\n' "$(versioning_repo_root)"
}

versioning_current() {
  path=$(versioning_path)
  [ -f "$path" ] || versioning_die "missing root VERSION file"
  sed -n '1p' "$path"
}

versioning_validate() {
  value=$1
  LC_ALL=C printf '%s\n' "$value" | grep -Eq '^v[0-9]+\.[0-9]\.[0-9]-[0-9]{6}[0-9a-z]$' \
    || versioning_die "invalid VERSION identifier: $value"

  rest=${value#v}
  version_part=${rest%%-*}
  build_part=${rest#*-}
  major=${version_part%%.*}
  minor_patch=${version_part#*.}
  minor=${minor_patch%%.*}
  patch=${minor_patch#*.}
  date_part=${build_part%?}
  counter=${build_part#??????}

  canonical=$(date -u -d "20${date_part}" +%y%m%d 2>/dev/null || true)
  [ "$canonical" = "$date_part" ] || versioning_die "invalid build date: $date_part"

  build_epoch=$(date -u -d "20${date_part} 00:00:00" +%s 2>/dev/null || true)
  now_epoch=$(date -u +%s)
  [ -n "$build_epoch" ] && [ "$build_epoch" -le "$now_epoch" ] \
    || versioning_die "future-dated build identifier: $value"

  case $counter in
    1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z) ;;
    *) versioning_die "invalid build counter: $counter" ;;
  esac
}

versioning_next_counter() {
  case $1 in
    1) printf '2\n' ;; 2) printf '3\n' ;; 3) printf '4\n' ;;
    4) printf '5\n' ;; 5) printf '6\n' ;; 6) printf '7\n' ;;
    7) printf '8\n' ;; 8) printf '9\n' ;; 9) printf 'a\n' ;;
    a) printf 'b\n' ;; b) printf 'c\n' ;; c) printf 'd\n' ;;
    d) printf 'e\n' ;; e) printf 'f\n' ;; f) printf 'g\n' ;;
    g) printf 'h\n' ;; h) printf 'i\n' ;; i) printf 'j\n' ;;
    j) printf 'k\n' ;; k) printf 'l\n' ;; l) printf 'm\n' ;;
    m) printf 'n\n' ;; n) printf 'o\n' ;; o) printf 'p\n' ;;
    p) printf 'q\n' ;; q) printf 'r\n' ;; r) printf 's\n' ;;
    s) printf 't\n' ;; t) printf 'u\n' ;; u) printf 'v\n' ;;
    v) printf 'w\n' ;; w) printf 'x\n' ;; x) printf 'y\n' ;;
    y) printf 'z\n' ;;
    z) versioning_die "daily build counter exhausted for current UTC date" ;;
    *) versioning_die "cannot advance unknown build counter: $1" ;;
  esac
}

versioning_next_identifier() {
  current=$1
  versioning_validate "$current"

  rest=${current#v}
  version_part=${rest%%-*}
  build_part=${rest#*-}
  major=${version_part%%.*}
  minor_patch=${version_part#*.}
  minor=${minor_patch%%.*}
  patch=${minor_patch#*.}
  old_date=${build_part%?}
  old_counter=${build_part#??????}

  if [ "$patch" -lt 9 ]; then
    patch=$((patch + 1))
  else
    patch=0
    if [ "$minor" -lt 9 ]; then
      minor=$((minor + 1))
    else
      minor=0
      major=$((major + 1))
    fi
  fi

  today=$(date -u +%y%m%d)
  if [ "$old_date" = "$today" ]; then
    next_counter=$(versioning_next_counter "$old_counter")
  else
    next_counter=1
  fi

  printf 'v%s.%s.%s-%s%s\n' "$major" "$minor" "$patch" "$today" "$next_counter"
}

versioning_advance_file() {
  path=$(versioning_path)
  current=$(versioning_current)
  next=$(versioning_next_identifier "$current")
  temporary=${path}.tmp.$$
  trap 'rm -f "$temporary"' 0 HUP INT TERM
  printf '%s\n' "$next" > "$temporary"
  mv -f "$temporary" "$path"
  git -C "$(versioning_repo_root)" add -- VERSION
  trap - 0 HUP INT TERM
}

versioning_stamp_message() {
  message_file=$1
  prefix=$2
  temporary=${message_file}.tmp.$$
  trap 'rm -f "$temporary"' 0 HUP INT TERM
  awk -v prefix="$prefix" '
    BEGIN { stamped = 0 }
    {
      if (!stamped && $0 !~ /^#/ && $0 != "") {
        sub(/^v[0-9]+\.[0-9]\.[0-9]-[0-9]{6}[0-9a-z][[:space:]]+/, "", $0)
        print prefix " " $0
        stamped = 1
      } else {
        print $0
      }
    }
  ' "$message_file" > "$temporary"
  mv -f "$temporary" "$message_file"
  trap - 0 HUP INT TERM
}
