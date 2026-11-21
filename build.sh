#!/bin/sh
# index.html은 claude.ai 아티팩트용 원본(문서 머리 없음)입니다.
# 배포용 docs/index.html은 doctype, charset, viewport를 갖춘 독립 페이지로 감싸서 만듭니다.
set -e
cd "$(dirname "$0")"
mkdir -p docs
python3 - <<'EOF'
src = open('index.html', encoding='utf-8').read()
cut = src.index('</style>') + len('</style>')
head, body = src[:cut], src[cut:]
page = ('<!doctype html>\n<html lang="ko">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
        '<meta name="description" content="카메라 무빙, 샷 구도, 다이나믹 편집, 장면 전환을 3D 미리보기와 복사용 프롬프트로 보는 촬영·편집 기법 사전">\n'
        '<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>\n'
        + head + '\n</head>\n<body>\n' + body + '\n</body>\n</html>\n')
open('docs/index.html', 'w', encoding='utf-8').write(page)
EOF
echo "built docs/index.html"
