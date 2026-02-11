*** Settings ***
Documentation     Testes da tela de Detalhes da Lista do QuickList
...               Cobertura: CRUD de itens, catálogo, preços, histórico, busca
Library           SeleniumLibrary
Resource          ../resources/common.resource
Resource          ../resources/pages/list_detail_page.resource
Resource          ../resources/pages/lists_page.resource

Suite Setup       Log    Iniciando testes de Detalhes da Lista
Suite Teardown    Close All Browsers
Test Teardown     Close Test Browser

*** Test Cases ***
# ============================================
# Testes de Exibição - Elementos Básicos
# ============================================

List Detail Screen Should Display Header With List Name
    [Documentation]    Verifica se o header mostra o nome da lista
    [Tags]    list-detail    ui    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify List Detail Screen Is Displayed
    Verify List Title    Lista de Compras

List Detail Screen Should Display Back Button
    [Documentation]    Verifica se o botão voltar está visível
    [Tags]    list-detail    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify Back Button Is Displayed

List Detail Screen Should Display Shopping Mode Button
    [Documentation]    Verifica se o botão modo compra está visível
    [Tags]    list-detail    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify Shopping Mode Button Is Displayed

List Detail Screen Should Display Progress Bar
    [Documentation]    Verifica se a barra de progresso está visível
    [Tags]    list-detail    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify Progress Bar Is Displayed

List Detail Screen Should Display Quick Add Section
    [Documentation]    Verifica se a seção de quick add está visível
    [Tags]    list-detail    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify Quick Add Is Displayed

# ============================================
# Testes de Estado Vazio
# ============================================

Empty List Should Show Empty State Message
    [Documentation]    Lista vazia deve mostrar mensagem
    [Tags]    list-detail    empty-state
    Setup Test With Authenticated User
    # Criar lista vazia
    Create New List    Lista Vazia
    Click On List To Open Details    Lista Vazia
    Verify Items Empty State Is Displayed

# ============================================
# Testes de Quick Add
# ============================================

User Should Be Able To Add Item Via Quick Add
    [Documentation]    Verifica adição de item via quick add
    [Tags]    list-detail    quick-add    smoke
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item And Verify    ${TEST_ITEM_NAME}

User Should Be Able To Add Item By Pressing Enter
    [Documentation]    Verifica adição de item pressionando Enter
    [Tags]    list-detail    quick-add
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item Via Quick Add With Enter    ${TEST_ITEM_NAME}
    Verify Item Exists    ${TEST_ITEM_NAME}

Quick Add Input Should Clear After Adding Item
    [Documentation]    Input deve limpar após adicionar item
    [Tags]    list-detail    quick-add
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item Via Quick Add    ${TEST_ITEM_NAME}
    Verify Quick Add Input Is Empty

User Should Be Able To Add Multiple Items
    [Documentation]    Verifica adição de múltiplos itens
    [Tags]    list-detail    quick-add    multiple
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item And Verify    ${TEST_ITEM_NAME}
    Add Item And Verify    ${TEST_ITEM_NAME_2}
    Add Item And Verify    ${TEST_ITEM_NAME_3}
    Verify Item Count    3

# ============================================
# Testes de Catálogo
# ============================================

User Should Be Able To Open Catalog Modal
    [Documentation]    Verifica abertura do modal de catálogo
    [Tags]    list-detail    catalog    modal
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Open Catalog Modal
    Verify Catalog Modal Is Displayed

Catalog Should Display Category Tabs
    [Documentation]    Catálogo deve exibir abas de categorias
    [Tags]    list-detail    catalog
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Open Catalog Modal
    Page Should Contain    Todos
    Page Should Contain    Frutas
    Page Should Contain    Laticínios

User Should Be Able To Select Items From Catalog
    [Documentation]    Verifica seleção de itens do catálogo
    [Tags]    list-detail    catalog    smoke
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Items From Catalog    Maçã    Banana

User Should Be Able To Filter Catalog Items
    [Documentation]    Verifica filtro de itens do catálogo
    [Tags]    list-detail    catalog    search
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Open Catalog Modal
    Search In Catalog    Maçã
    Page Should Contain    Maçã

User Should Be Able To Switch Catalog Categories
    [Documentation]    Verifica troca de categorias no catálogo
    [Tags]    list-detail    catalog    categories
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Open Catalog Modal
    Select Catalog Category    Frutas
    Page Should Contain    Maçã
    Page Should Contain    Banana

User Should Be Able To Add Custom Item Via Catalog
    [Documentation]    Verifica adição de item customizado via catálogo
    [Tags]    list-detail    catalog    custom
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Open Catalog Modal
    Enter Custom Catalog Item    Item Personalizado
    Click Add Items From Catalog
    Verify Item Exists    Item Personalizado

User Should Be Able To Close Catalog Without Adding
    [Documentation]    Verifica fechamento do catálogo sem adicionar
    [Tags]    list-detail    catalog    modal
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Open Catalog Modal
    Close Catalog Modal
    Verify Items Empty State Is Displayed

# ============================================
# Testes de Edição de Item
# ============================================

User Should Be Able To Edit Item Name
    [Documentation]    Verifica edição de nome do item
    [Tags]    list-detail    edit    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Edit Button For Item    Arroz
    Edit Item Name    ${TEST_ITEM_NAME_EDITED}
    Verify Item Exists    ${TEST_ITEM_NAME_EDITED}
    Verify Item Does Not Exist    Arroz

# ============================================
# Testes de Exclusão de Item
# ============================================

User Should Be Able To Delete Item
    [Documentation]    Verifica exclusão de item
    [Tags]    list-detail    delete    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Delete Item And Verify    Arroz

User Should Be Able To Cancel Item Deletion
    [Documentation]    Verifica cancelamento de exclusão
    [Tags]    list-detail    delete    modal
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Delete Button For Item    Arroz
    Cancel Delete Item
    Verify Item Exists    Arroz

# ============================================
# Testes de Marcar como Comprado
# ============================================

User Should Be Able To Mark Item As Bought With Price
    [Documentation]    Verifica marcação de item com preço
    [Tags]    list-detail    buy    price    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    Verify Item Has Price Badge    Arroz    ${TEST_PRICE}

User Should Be Able To Mark Item As Bought Without Price
    [Documentation]    Verifica marcação de item sem preço
    [Tags]    list-detail    buy
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought Without Price    Arroz

Buy Modal Should Display Item Name
    [Documentation]    Modal de compra deve mostrar nome do item
    [Tags]    list-detail    buy    modal
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Item Checkbox    Arroz
    Verify Buy Modal Is Displayed
    Verify Buy Modal Item Name    Arroz

Progress Should Update After Marking Item As Bought
    [Documentation]    Progresso deve atualizar após marcar item
    [Tags]    list-detail    buy    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify Progress Text    1    2
    Mark Item As Bought Without Price    Arroz
    Verify Progress Text    2    2

# ============================================
# Testes de Histórico de Preços
# ============================================

User Should Be Able To Open Price History Modal
    [Documentation]    Verifica abertura do modal de histórico
    [Tags]    list-detail    history    modal
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Price History Button For Item    Feijão
    Verify Price History Modal Is Displayed

Price History Should Show Best Price
    [Documentation]    Histórico deve mostrar melhor preço
    [Tags]    list-detail    history    price
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    # Primeiro, adicionar preço ao item
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    Click Price History Button For Item    Arroz
    Verify Best Price In History    ${TEST_PRICE}

Empty Price History Should Show Message
    [Documentation]    Histórico vazio deve mostrar mensagem
    [Tags]    list-detail    history    empty-state
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Price History Button For Item    Arroz
    Verify Price History Is Empty

User Should Be Able To Close Price History Modal
    [Documentation]    Verifica fechamento do modal de histórico
    [Tags]    list-detail    history    modal
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Price History Button For Item    Arroz
    Close Price History Modal
    Element Should Not Be Visible    ${PRICE_HISTORY_MODAL}

# ============================================
# Testes de Busca
# ============================================

Search Should Filter Items
    [Documentation]    Busca deve filtrar itens
    [Tags]    list-detail    search
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Search For Item    Arroz
    Verify Item Exists    Arroz
    Page Should Not Contain    Feijão

Search Should Be Case Insensitive
    [Documentation]    Busca deve ignorar maiúsculas/minúsculas
    [Tags]    list-detail    search
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Search For Item    arroz
    Verify Item Exists    Arroz

Search Should Handle Accents
    [Documentation]    Busca deve lidar com acentos
    [Tags]    list-detail    search
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item Via Quick Add    Maçã
    Search For Item    maca
    Page Should Contain    Maçã

Clear Search Should Show All Items
    [Documentation]    Limpar busca deve mostrar todos os itens
    [Tags]    list-detail    search
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Search For Item    Arroz
    Clear Search
    Verify Item Exists    Arroz
    Verify Item Exists    Feijão

# ============================================
# Testes de Navegação
# ============================================

Back Button Should Return To Lists Screen
    [Documentation]    Botão voltar deve retornar para listas
    [Tags]    list-detail    navigation
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Back Button
    Verify Lists Screen Is Displayed

Shopping Mode Button Should Navigate To Shopping Mode
    [Documentation]    Botão modo compra deve navegar
    [Tags]    list-detail    navigation    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Wait Until Page Contains Element    css:[data-testid="shopping-mode-screen"]    ${TIMEOUT}

# ============================================
# Testes de Progress Bar
# ============================================

Progress Bar Should Show Correct Percentage
    [Documentation]    Barra de progresso deve mostrar percentual correto
    [Tags]    list-detail    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    # 1 de 2 itens comprados = 50%
    ${width}=    Get Progress Percentage
    Should Be Equal    ${width}    50

Progress Bar Should Update In Real Time
    [Documentation]    Barra de progresso deve atualizar em tempo real
    [Tags]    list-detail    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    ${initial_width}=    Get Progress Percentage
    Mark Item As Bought Without Price    Arroz
    ${new_width}=    Get Progress Percentage
    Should Be True    ${new_width} > ${initial_width}

# ============================================
# Testes de Validação
# ============================================

Empty Item Name Should Not Be Accepted
    [Documentation]    Nome vazio não deve ser aceito
    [Tags]    list-detail    validation
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Input Text When Ready    ${QUICK_ADD_INPUT}    ${EMPTY}
    Element Should Be Disabled    ${QUICK_ADD_BUTTON}

Whitespace Only Item Name Should Not Be Accepted
    [Documentation]    Apenas espaços não deve ser aceito
    [Tags]    list-detail    validation
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Input Text When Ready    ${QUICK_ADD_INPUT}    ${SPACE}${SPACE}${SPACE}
    Element Should Be Disabled    ${QUICK_ADD_BUTTON}

# ============================================
# Testes de Market Autocomplete
# ============================================

Market Input Should Show Suggestions
    [Documentation]    Input de mercado deve mostrar sugestões
    [Tags]    list-detail    buy    autocomplete
    Setup Test With Sample Data
    # Primeiro registrar um mercado
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    # Depois verificar se aparece nas sugestões
    Click Item Checkbox    Feijão
    Verify Buy Modal Is Displayed
    Enter Market In Buy Modal    Super
    # Verificar se sugestão aparece
    Wait Until Element Is Visible    ${MARKET_SUGGESTIONS}    ${SHORT_TIMEOUT}
