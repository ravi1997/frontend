#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mkdir -p \
  lib/app/router \
  lib/app/theme \
  lib/app/localization \
  lib/app/startup \
  lib/core/constants \
  lib/core/config \
  lib/core/networking \
  lib/core/security \
  lib/core/storage \
  lib/core/analytics \
  lib/core/logging \
  lib/core/permissions \
  lib/core/widgets \
  lib/core/errors \
  lib/core/extensions \
  lib/core/utils \
  lib/core/services \
  lib/shared/models \
  lib/shared/enums \
  lib/shared/mixins \
  lib/shared/validators \
  lib/shared/widgets \
  lib/modules/auth \
  lib/modules/dashboard/widgets \
  lib/modules/dashboard/models \
  lib/modules/analytics/pages \
  lib/modules/analytics/widgets \
  lib/modules/analytics/models \
  lib/modules/forms/responses/controllers \
  lib/modules/forms/responses/pages \
  lib/modules/forms/responses/data/mappers \
  lib/modules/forms/responses/data/repositories \
  lib/modules/forms/responses/data/services \
  lib/modules/forms/models \
  lib/modules/forms/pages \
  lib/modules/forms/widgets \
  lib/modules/forms/services \
  lib/modules/forms/data/dto \
  lib/modules/forms/data/mappers \
  lib/modules/forms/data/models \
  lib/modules/forms/data/repositories \
  lib/modules/forms/utils \
  lib/modules/platform \
  lib/generated

move_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -e "$src" && "$src" != "$dst" ]]; then
    mkdir -p "$(dirname "$dst")"
    mv "$src" "$dst"
  fi
}

move_dir_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -d "$src" && "$src" != "$dst" ]]; then
    mkdir -p "$(dirname "$dst")"
    mv "$src" "$dst"
  fi
}

move_if_exists lib/app/router.dart lib/app/router/router.dart
move_if_exists lib/app/app_config.dart lib/app/startup/app_config.dart
move_if_exists lib/shared/ui/design_system.dart lib/app/theme/design_system.dart
move_if_exists lib/core/theme/app_colors.dart lib/app/theme/app_colors.dart
move_if_exists lib/core/theme/app_theme.dart lib/app/theme/app_theme.dart
move_if_exists lib/core/theme/theme_controller.dart lib/app/theme/theme_controller.dart
move_if_exists lib/core/design_system/tokens.dart lib/app/theme/tokens.dart
move_if_exists lib/core/design_system/design_system.dart lib/app/theme/design_system.dart
move_if_exists lib/core/localization/locale_controller.dart lib/app/localization/locale_controller.dart
move_if_exists lib/core/locale_controller.dart lib/app/localization/locale_controller_legacy.dart
move_if_exists lib/core/layout/app_shell.dart lib/app/startup/app_shell.dart
move_if_exists lib/core/layout/responsive.dart lib/core/widgets/responsive.dart
move_if_exists lib/core/exceptions/app_exception.dart lib/core/errors/app_exception.dart
move_if_exists lib/core/app_exception.dart lib/core/errors/app_exception_legacy.dart
move_if_exists lib/core/form_models.dart lib/shared/models/form_models.dart
move_if_exists lib/models/form_models.dart lib/shared/models/form_models.dart
move_if_exists lib/core/base_controller_mixin.dart lib/shared/mixins/base_controller_mixin.dart
move_if_exists lib/core/connectivity_service.dart lib/core/services/connectivity_service_legacy.dart

if [[ -d lib/core/network ]]; then
  shopt -s nullglob
  for f in lib/core/network/*; do
    mv "$f" "lib/core/networking/$(basename "$f")"
  done
  shopt -u nullglob
fi

if [[ -d lib/shared/widgets ]]; then
  shopt -s nullglob
  for f in lib/shared/widgets/*; do
    dst="lib/shared/widgets/1000 4 24 27 30 46 100 114 125 129 981 995 1000basename "")"
    [[ "" == "" ]] && continue
    mv "" ""
  done
  shopt -u nullglob
fi

if [[ -d lib/core/widgets ]]; then
  shopt -s nullglob
  for f in lib/core/widgets/*; do
    dst="lib/core/widgets/1000 4 24 27 30 46 100 114 125 129 981 995 1000basename "")"
    [[ "" == "" ]] && continue
    mv "" ""
  done
  shopt -u nullglob
fi

if [[ -d lib/core/utils ]]; then
  shopt -s nullglob
  for f in lib/core/utils/*; do
    dst="lib/core/utils/1000 4 24 27 30 46 100 114 125 129 981 995 1000basename "")"
    [[ "" == "" ]] && continue
    mv "" ""
  done
  shopt -u nullglob
fi

move_dir_if_exists lib/features/auth lib/modules/auth
move_dir_if_exists lib/features/dashboard lib/modules/dashboard
move_dir_if_exists lib/features/analytics lib/modules/analytics
move_dir_if_exists lib/features/platform lib/modules/platform
move_dir_if_exists lib/features/form_builder lib/modules/forms
move_dir_if_exists lib/features/responses lib/modules/forms/responses

move_if_exists lib/modules/dashboard/domain/entities/project_summary.dart lib/modules/dashboard/models/project_summary.dart

rmdir lib/features/dashboard/domain/entities 2>/dev/null || true
rmdir lib/features/dashboard/domain 2>/dev/null || true
rmdir lib/features/dashboard 2>/dev/null || true
rmdir lib/features/auth 2>/dev/null || true
rmdir lib/features/analytics 2>/dev/null || true
rmdir lib/features/platform 2>/dev/null || true
rmdir lib/features/form_builder 2>/dev/null || true
rmdir lib/features/responses 2>/dev/null || true
rmdir lib/features 2>/dev/null || true
rmdir lib/core/network 2>/dev/null || true
rmdir lib/core/layout 2>/dev/null || true
rmdir lib/core/theme 2>/dev/null || true
rmdir lib/core/design_system 2>/dev/null || true
rmdir lib/core/exceptions 2>/dev/null || true
rmdir lib/core 2>/dev/null || true
rmdir lib/shared/ui 2>/dev/null || true

python3 - <<'PY'
from pathlib import Path

root = Path('lib')
replacements = [
    ('package:frontend/features/', 'package:frontend/modules/'),
    ('package:frontend/core/network/', 'package:frontend/core/networking/'),
    ('package:frontend/core/theme/', 'package:frontend/app/theme/'),
    ('package:frontend/core/design_system/', 'package:frontend/app/theme/'),
    ('package:frontend/core/localization/', 'package:frontend/app/localization/'),
    ('package:frontend/core/layout/', 'package:frontend/app/startup/'),
    ('package:frontend/core/exceptions/', 'package:frontend/core/errors/'),
    ('package:frontend/core/form_models.dart', 'package:frontend/shared/models/form_models.dart'),
    ('package:frontend/core/shared_ui.dart', 'package:frontend/shared/widgets/shared_ui.dart'),
    ('package:frontend/core/base_controller_mixin.dart', 'package:frontend/shared/mixins/base_controller_mixin.dart'),
    ('package:frontend/shared/ui/design_system.dart', 'package:frontend/app/theme/design_system.dart'),
    ('../core/theme/', '../app/theme/'),
    ('../../core/theme/', '../../app/theme/'),
    ('../../../core/theme/', '../../../app/theme/'),
    ('../../../../core/theme/', '../../../../app/theme/'),
    ('../core/localization/', '../app/localization/'),
    ('../../core/localization/', '../../app/localization/'),
    ('../../../core/localization/', '../../../app/localization/'),
    ('../../../../core/localization/', '../../../../app/localization/'),
    ('../core/network/', '../core/networking/'),
    ('../../core/network/', '../../core/networking/'),
    ('../../../core/network/', '../../../core/networking/'),
    ('../../../../core/network/', '../../../../core/networking/'),
    ('../features/', '../modules/'),
    ('../../features/', '../../modules/'),
    ('../../../features/', '../../../modules/'),
    ('../../../../features/', '../../../../modules/'),
]

for path in root.rglob('*'):
    if not path.is_file():
        continue
    if path.suffix not in {'.dart', '.md', '.yaml'}:
        continue
    text = path.read_text()
    new = text
    for old, rep in replacements:
        new = new.replace(old, rep)
    if new != text:
        path.write_text(new)
PY

echo 'Restructure complete.'
