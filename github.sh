#!/bin/sh

# =========================================
# SCRIPT: CRIAR BRANCH NO GITHUB PRESERVANDO HISTÓRICO
# USO: ./criar_branch.sh [nome-da-branch-base]
# =========================================

# =========================================
# CONFIGURAÇÃO (PODE EDITAR)
# =========================================

name="Narutex216Bits"
email="djxan@yahoo.com.br"
repositorio="https://github.com/Narutex216Bits/TekkitClassic-Computercraft-Programs.git"

# Parâmetro opcional: branch base (se não informado, usa "auto")
branch_base="${1:-auto}"
timestamp=$(date +%Y%m%d-%H%M%S)
branch_name="${timestamp}-${branch_base}"

# =========================================
# FUNÇÕES AUXILIARES
# =========================================

# Função para exibir mensagens de erro e sair
error_exit() {
    echo "❌ ERRO: $1" >&2
    exit 1
}

# Configura o repositório local
setup_git() {
    if [ ! -d .git ]; then
        echo "🚀 Inicializando repositório..."
        git init || error_exit "Falha ao inicializar repositório"
    else
        echo "📦 Repositório já inicializado."
    fi
}

# Configura o remote origin
setup_remote() {
    if ! git remote get-url origin >/dev/null 2>&1; then
        echo "🌐 Adicionando repositório remoto..."
        git remote add origin "$repositorio" || error_exit "Falha ao adicionar remote"
    else
        current_url=$(git remote get-url origin)
        if [ "$current_url" != "$repositorio" ]; then
            echo "🔄 Atualizando URL do repositório remoto..."
            git remote set-url origin "$repositorio" || error_exit "Falha ao atualizar remote"
        else
            echo "✅ Remote já está correto."
        fi
    fi
}

# Cria .gitignore se não existir
setup_gitignore() {
    if [ ! -f .gitignore ]; then
        echo "📁 Criando .gitignore..."
        cat <<EOL > .gitignore
# ===== SISTEMA OPERACIONAL =====
.DS_Store
Thumbs.db
desktop.ini

# ===== TEMPORÁRIOS =====
*~

# ===== LOGS =====
*.log

# ===== NODE / FIREBASE =====
node_modules/
.firebase/

# ===== FLUTTER =====
.build/
.dart_tool/
EOL
    else
        echo "📁 .gitignore já existe, mantendo."
    fi
}

# Cria a nova branch
create_branch() {
    # Verifica se a branch já existe localmente
    if git show-ref --verify --quiet refs/heads/"$branch_name"; then
        echo "⚠️ Branch $branch_name já existe localmente!"
        printf "Deseja usar mesmo assim? (s/N): "
        read -r resposta
        case "$resposta" in
            [sS]|[sS][iI][mM]) ;;
            *) exit 1 ;;
        esac
    fi

    echo "🌿 Criando nova branch: $branch_name"

    # Se branch_base não for "auto", tenta atualizar a branch base primeiro
    if [ "$branch_base" != "auto" ]; then
        echo "🔄 Baseando em: $branch_base"

        # Tenta fazer fetch da branch base do remoto
        git fetch origin "$branch_base" 2>/dev/null || echo "⚠️ Branch base não encontrada no remoto"

        # Muda para a branch base (cria localmente se não existir)
        if git checkout "$branch_base" 2>/dev/null; then
            git pull origin "$branch_base" 2>/dev/null || echo "⚠️ Não foi possível atualizar branch base"
        else
            git checkout -b "$branch_base" 2>/dev/null || error_exit "Falha ao criar branch base local"
        fi
    fi

    # Cria a nova branch
    if ! git switch -c "$branch_name" 2>/dev/null && ! git checkout -b "$branch_name" 2>/dev/null; then
        error_exit "Falha ao criar branch $branch_name"
    fi
}

# Adiciona, commita e faz push (se houver mudanças)
commit_and_push() {
    echo "📦 Adicionando arquivos..."
    git add .

    # Verifica se há mudanças para commit
    if git diff --cached --quiet; then
        echo "⚠️ Nenhuma mudança para commitar"
        echo "✨ Branch criada localmente, mas sem commits"
        echo "🔗 Branch local: $branch_name"
        return 0
    fi

    echo "💾 Criando commit..."
    git commit -m "Auto commit: $branch_name" || error_exit "Falha ao commitar"

    echo "📤 Enviando para GitHub..."
    if git push -u origin "$branch_name"; then
        echo "✅ Push realizado com sucesso!"
        return 0
    else
        error_exit "Falha ao fazer push para o GitHub"
    fi
}

# =========================================
# EXECUÇÃO PRINCIPAL
# =========================================

main() {
    echo "🚀 Iniciando processo de criação de branch..."
    echo "📌 Nome da branch: $branch_name"
    echo "📌 Baseada em: $branch_base"
    echo ""

    setup_git
    setup_remote
    setup_gitignore

    # Configura nome e email localmente
    git config user.name "$name" || error_exit "Falha ao configurar user.name"
    git config user.email "$email" || error_exit "Falha ao configurar user.email"

    create_branch
    commit_and_push

    echo ""
    echo "🎉 Processo concluído com sucesso!"
    echo "🔗 Branch criada: $branch_name"
    echo "💡 Para voltar à branch anterior: git checkout -"
}

# Executa o script
main