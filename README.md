# Comando para hacer un PR rápidamente

### Ejemplo de uso

```bash
pr feat: trlabajar a lo malditto
```
Ejecutar el comando anterior en la consola hace lo siguiente:
1. Crea rama `feat/trlabajar-a-lo-malditto` y se mueve a ella
2. Commitea tomando **solo los cambios en git stage**. El mensaje del commit será "feat: trlabajar a lo malditto"
3. Pushea a la rama
4. Abre el navegador con el PR apuntando hacia master/main

### Configuración

Para la shell `zsh`:
1. En `~/.zshrc`, cargar este archivo haciendo `source ~/comando-fast-PR/.zsh_functions.sh`
2. Luego de hacer cambios en esta función se debe recargar la configuración con `source ~/.zshrc`
