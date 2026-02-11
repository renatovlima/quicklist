# Testes Robot Framework - QuickList

Suite de testes automatizados para a aplicação QuickList usando Robot Framework com Selenium.

## Estrutura do Projeto

```
tests/
├── resources/
│   ├── common.resource           # Keywords e configurações comuns
│   ├── variables.resource        # Variáveis globais
│   └── pages/
│       ├── login_page.resource   # Page Object - Login
│       ├── lists_page.resource   # Page Object - Listas
│       ├── list_detail_page.resource  # Page Object - Detalhes
│       └── shopping_mode_page.resource # Page Object - Modo Compra
├── login/
│   └── login_tests.robot         # Testes de login
├── lists/
│   └── lists_tests.robot         # Testes de listas
├── list_detail/
│   └── list_detail_tests.robot   # Testes de detalhes
├── shopping_mode/
│   └── shopping_mode_tests.robot # Testes de modo compra
├── persistence/
│   └── persistence_tests.robot   # Testes de persistência
├── requirements.txt              # Dependências Python
├── robot.yaml                    # Configuração Robot Framework
└── README.md                     # Este arquivo
```

## Pré-requisitos

1. **Python 3.8+** instalado
2. **Google Chrome** instalado
3. **Node.js 18+** para executar a aplicação

## Instalação

### 1. Criar ambiente virtual (recomendado)

```bash
cd tests
python -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
venv\Scripts\activate     # Windows
```

### 2. Instalar dependências

```bash
pip install -r requirements.txt
```

### 3. Instalar ChromeDriver

O ChromeDriver será gerenciado automaticamente pelo webdriver-manager, mas você também pode instalar manualmente:

```bash
# Via webdriver-manager (automático)
pip install webdriver-manager

# Ou manualmente via Homebrew (Mac)
brew install chromedriver
```

## Executando os Testes

### 1. Iniciar a aplicação

Em um terminal separado:

```bash
cd ..  # Voltar para o diretório raiz
npm run dev
```

A aplicação estará disponível em `http://localhost:5173`

### 2. Executar todos os testes

```bash
robot tests/
```

### 3. Executar testes específicos

```bash
# Apenas testes de login
robot tests/login/

# Apenas testes de listas
robot tests/lists/

# Apenas testes de detalhes
robot tests/list_detail/

# Apenas testes de modo compra
robot tests/shopping_mode/

# Apenas testes de persistência
robot tests/persistence/
```

### 4. Executar por tags

```bash
# Apenas testes smoke
robot --include=smoke tests/

# Excluir testes de persistência
robot --exclude=persistence tests/

# Apenas testes de UI
robot --include=ui tests/

# Múltiplas tags
robot --include=smoke --include=login tests/
```

### 5. Executar em modo headless

```bash
robot --variable=HEADLESS:True tests/
```

### 6. Executar com relatório customizado

```bash
robot --outputdir=reports --name="QuickList Tests" tests/
```

## Tags Disponíveis

| Tag | Descrição |
|-----|-----------|
| `smoke` | Testes essenciais de sanidade |
| `ui` | Testes de interface visual |
| `login` | Testes de autenticação |
| `lists` | Testes de gerenciamento de listas |
| `list-detail` | Testes de detalhes da lista |
| `shopping-mode` | Testes do modo compra |
| `persistence` | Testes de persistência de dados |
| `create` | Testes de criação |
| `edit` | Testes de edição |
| `delete` | Testes de exclusão |
| `navigation` | Testes de navegação |
| `modal` | Testes de modais |
| `validation` | Testes de validação |
| `price` | Testes de preços |
| `catalog` | Testes de catálogo |
| `search` | Testes de busca |

## Relatórios

Após a execução, os seguintes arquivos são gerados no diretório de saída:

- `report.html` - Relatório resumido
- `log.html` - Log detalhado de execução
- `output.xml` - Saída em formato XML

Abra `report.html` no navegador para visualizar os resultados.

## Execução Paralela

Para executar testes em paralelo (mais rápido):

```bash
pabot --processes 4 tests/
```

## Configuração Adicional

### Variáveis de Ambiente

Você pode sobrescrever variáveis via linha de comando:

```bash
robot --variable=BASE_URL:http://localhost:3000 \
      --variable=BROWSER:firefox \
      --variable=TIMEOUT:30s \
      tests/
```

### Modo Debug

Para depuração, execute com log level DEBUG:

```bash
robot --loglevel=DEBUG tests/
```

## Cobertura de Testes

### LoginScreen
- Exibição de elementos (logo, título, botão)
- Autenticação com Google
- Redirecionamento após login
- Persistência de sessão

### ListsScreen
- CRUD completo de listas
- Estado vazio
- Navegação para detalhes
- Logout

### ListDetailScreen
- Quick add de itens
- Catálogo de produtos
- Edição e exclusão de itens
- Marcar como comprado
- Histórico de preços
- Busca e filtros
- Navegação para modo compra

### ShoppingModeScreen
- Exibição de itens pendentes/comprados
- Toggle de status
- Barra de progresso
- Modal de compra
- Navegação

### Persistência
- Dados persistem após refresh
- Sincronização entre telas
- Integridade referencial
- Múltiplas abas

## Resolução de Problemas

### ChromeDriver não encontrado

```bash
pip install --upgrade webdriver-manager
```

### Timeout em elementos

Aumente o timeout global:

```bash
robot --variable=TIMEOUT:30s tests/
```

### Testes falhando por elementos não encontrados

Verifique se os componentes React têm os atributos `data-testid` corretos.

## Contribuindo

1. Mantenha os Page Objects atualizados
2. Use tags apropriadas nos testes
3. Documente novos keywords
4. Siga o padrão de nomenclatura existente
