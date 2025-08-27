#!/bin/sh
#
# En '~/.zshrc', cargar este archivo haciendo 'source ~/comando-fast-PR/.zsh_functions.sh'
#
# Luego de hacer cambios en esta función se debe recargar la configuración con 'source ~/.zshrc'
#
pr() {
    # 1. Ver si hay cambios en stage
    if git diff --cached --quiet; then
        printf "[fast PR] ⚠️  No hay cambios en stage. Nada que commitear.\n"
        return 1
    fi

    # 2. Mensaje original (todos los parámetros juntos)
    msg="$*"

    # 3. Separar prefijo y resto
    prefix=$(printf "%s" "$msg" | cut -d':' -f1)
    rest=$(printf "%s" "$msg" | cut -d':' -f2- | sed 's/^ *//')

    # 4. Normalizar el resto (sin acentos, minúsculas, espacios->guiones)
    rest_slug=$(printf "%s" "$rest" \
        | iconv -t ascii//TRANSLIT \
        | tr '[:upper:]' '[:lower:]' \
        | sed -E 's/[^a-z0-9]+/-/g' \
        | sed -E 's/^-+|-+$//g')

    # 5. Nombre final de la rama
    branch="${prefix}/${rest_slug}"

    # 6. Revisar si la rama ya existe
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        printf "[fast PR] ⚠️  La rama '%s' ya existe localmente. Usando esa rama.\n" "$branch"
    else
        git checkout -b "$branch" || return 1
        printf "[fast PR] ✅  Rama creada."
    fi

    # 7. Hacer commit
    git commit -m "$msg"
    exit_code=$?
    if [ "$exit_code" -ne 0 ]; then
        printf "[fast PR] ❌ git commit falló con código %s\n" "$exit_code"
        return "$exit_code"
    fi

    printf "[fast PR] ✅  Listo el commit."

    # 8. Push al remoto
    git push -u origin "$branch" || return 1

    # 9. Abrir navegador con el PR hacia master/main
    repo_url=$(git remote get-url origin \
        | sed -E 's/git@github.com:/https:\/\/github.com\//; s/\.git$//')
    open "$repo_url/pull/new/$branch"
}

