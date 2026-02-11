*** Settings ***
Documentation     Testes da tela de Listas do QuickList
...               Cobertura: CRUD de listas, navegação, estado vazio, logout
Library           SeleniumLibrary
Resource          ../resources/common.resource
Resource          ../resources/pages/lists_page.resource
Resource          ../resources/pages/login_page.resource

Suite Setup       Log    Iniciando testes de Listas
Suite Teardown    Close All Browsers
Test Teardown     Close Test Browser

*** Test Cases ***
# ============================================
# Testes de Exibição - Estado Vazio
# ============================================

Lists Screen Should Display Header
    [Documentation]    Verifica se o header está exibido corretamente
    [Tags]    lists    ui    smoke
    Setup Test With Authenticated User
    Verify Lists Screen Is Displayed
    Verify Header Title Is QuickList

Lists Screen Should Display Logout Button
    [Documentation]    Verifica se o botão de logout está visível
    [Tags]    lists    ui
    Setup Test With Authenticated User
    Verify Logout Button Is Displayed

Lists Screen Should Display FAB
    [Documentation]    Verifica se o FAB está visível
    [Tags]    lists    ui    smoke
    Setup Test With Authenticated User
    Verify FAB Is Displayed

Lists Screen Should Show Empty State When No Lists
    [Documentation]    Verifica mensagem de estado vazio
    [Tags]    lists    ui    empty-state
    Setup Test With Authenticated User
    Verify Empty State Is Displayed

# ============================================
# Testes de Exibição - Com Listas
# ============================================

Lists Screen Should Display Existing Lists
    [Documentation]    Verifica se listas existentes são exibidas
    [Tags]    lists    ui
    Setup Test With Sample Data
    Verify Lists Screen Is Displayed
    Verify Empty State Is Not Displayed
    Verify List Count    2

Lists Screen Should Display List Names
    [Documentation]    Verifica se nomes das listas são exibidos
    [Tags]    lists    ui
    Setup Test With Sample Data
    Verify List Exists With Name    Lista de Compras
    Verify List Exists With Name    Lista do Mês

Lists Screen Should Display List Progress
    [Documentation]    Verifica se progresso das listas é exibido
    [Tags]    lists    ui
    Setup Test With Sample Data
    Verify List Progress Text    Lista de Compras    1/2 itens comprados

# ============================================
# Testes de Criação de Lista
# ============================================

User Should Be Able To Open Create List Modal
    [Documentation]    Verifica abertura do modal de criação
    [Tags]    lists    create    modal
    Setup Test With Authenticated User
    Click FAB To Create List
    Wait Until Element Is Visible    ${LIST_FORM_MODAL}    ${TIMEOUT}

Create List Modal Should Have Empty Input Initially
    [Documentation]    Verifica se input está vazio ao abrir modal
    [Tags]    lists    create    modal
    Setup Test With Authenticated User
    Click FAB To Create List
    ${value}=    Get Value    ${LIST_FORM_INPUT}
    Should Be Empty    ${value}

Create List Button Should Be Disabled When Input Is Empty
    [Documentation]    Botão de criar deve estar desabilitado com input vazio
    [Tags]    lists    create    validation
    Setup Test With Authenticated User
    Click FAB To Create List
    Verify Submit Button Is Disabled

Create List Button Should Be Enabled When Input Has Text
    [Documentation]    Botão de criar deve estar habilitado com texto
    [Tags]    lists    create    validation
    Setup Test With Authenticated User
    Click FAB To Create List
    Enter List Name    ${TEST_LIST_NAME}
    Verify Submit Button Is Enabled

User Should Be Able To Create A New List
    [Documentation]    Verifica criação de nova lista
    [Tags]    lists    create    smoke
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Verify List Exists With Name    ${TEST_LIST_NAME}
    Verify Empty State Is Not Displayed

User Should Be Able To Cancel List Creation
    [Documentation]    Verifica cancelamento de criação
    [Tags]    lists    create    modal
    Setup Test With Authenticated User
    Click FAB To Create List
    Enter List Name    ${TEST_LIST_NAME}
    Click Cancel On List Form
    Verify Empty State Is Displayed

New List Should Appear In List
    [Documentation]    Nova lista deve aparecer na lista
    [Tags]    lists    create
    Setup Test With Sample Data
    Create New List    ${TEST_LIST_NAME}
    Verify List Count    3
    Verify List Exists With Name    ${TEST_LIST_NAME}

New List Should Show Empty Progress
    [Documentation]    Nova lista deve mostrar progresso vazio
    [Tags]    lists    create
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Verify List Progress Text    ${TEST_LIST_NAME}    ${MSG_PROGRESS_EMPTY}

# ============================================
# Testes de Edição de Lista
# ============================================

User Should Be Able To Open Edit Modal
    [Documentation]    Verifica abertura do modal de edição
    [Tags]    lists    edit    modal
    Setup Test With Sample Data
    Click Edit Button For List    Lista de Compras
    Wait Until Element Is Visible    ${LIST_FORM_MODAL}    ${TIMEOUT}

Edit Modal Should Show Current List Name
    [Documentation]    Modal de edição deve mostrar nome atual
    [Tags]    lists    edit    modal
    Setup Test With Sample Data
    Click Edit Button For List    Lista de Compras
    ${value}=    Get Value    ${LIST_FORM_INPUT}
    Should Be Equal    ${value}    Lista de Compras

User Should Be Able To Edit List Name
    [Documentation]    Verifica edição de nome da lista
    [Tags]    lists    edit    smoke
    Setup Test With Sample Data
    Edit List    Lista de Compras    ${TEST_LIST_NAME_EDITED}
    Verify List Exists With Name    ${TEST_LIST_NAME_EDITED}
    Verify List Does Not Exist With Name    Lista de Compras

User Should Be Able To Cancel List Edit
    [Documentation]    Verifica cancelamento de edição
    [Tags]    lists    edit    modal
    Setup Test With Sample Data
    Click Edit Button For List    Lista de Compras
    Clear And Input Text    ${LIST_FORM_INPUT}    ${TEST_LIST_NAME_EDITED}
    Click Cancel On List Form
    Verify List Exists With Name    Lista de Compras
    Verify List Does Not Exist With Name    ${TEST_LIST_NAME_EDITED}

# ============================================
# Testes de Exclusão de Lista
# ============================================

User Should Be Able To Open Delete Confirmation
    [Documentation]    Verifica abertura do modal de confirmação
    [Tags]    lists    delete    modal
    Setup Test With Sample Data
    Click Delete Button For List    Lista de Compras
    Wait Until Element Is Visible    ${DELETE_CONFIRM_MODAL}    ${TIMEOUT}

Delete Confirmation Should Show List Name
    [Documentation]    Confirmação deve mostrar nome da lista
    [Tags]    lists    delete    modal
    Setup Test With Sample Data
    Click Delete Button For List    Lista de Compras
    Verify Delete Confirmation Message    Lista de Compras

User Should Be Able To Delete A List
    [Documentation]    Verifica exclusão de lista
    [Tags]    lists    delete    smoke
    Setup Test With Sample Data
    Delete List    Lista de Compras
    Verify List Count    1
    Verify List Does Not Exist With Name    Lista de Compras

User Should Be Able To Cancel List Deletion
    [Documentation]    Verifica cancelamento de exclusão
    [Tags]    lists    delete    modal
    Setup Test With Sample Data
    Click Delete Button For List    Lista de Compras
    Cancel Delete List
    Verify List Exists With Name    Lista de Compras
    Verify List Count    2

Deleting All Lists Should Show Empty State
    [Documentation]    Deletar todas as listas deve mostrar estado vazio
    [Tags]    lists    delete    empty-state
    Setup Test With Sample Data
    Delete List    Lista de Compras
    Delete List    Lista do Mês
    Verify Empty State Is Displayed

# ============================================
# Testes de Navegação
# ============================================

Clicking On List Should Navigate To Details
    [Documentation]    Clicar na lista deve navegar para detalhes
    [Tags]    lists    navigation    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Wait Until Page Contains Element    css:[data-testid="list-detail-screen"]    ${TIMEOUT}

# ============================================
# Testes de Logout
# ============================================

Clicking Logout Should Return To Login Screen
    [Documentation]    Clicar em logout deve voltar para login
    [Tags]    lists    logout    smoke
    Setup Test With Sample Data
    Click Logout Button
    Verify Login Screen Is Displayed

Logout Should Clear User Data
    [Documentation]    Logout deve limpar dados do usuário
    [Tags]    lists    logout    storage
    Setup Test With Sample Data
    Click Logout Button
    ${user_data}=    Get Local Storage Value    ${LS_USER}
    Should Be Equal    ${user_data}    ${NONE}

# ============================================
# Testes de Validação
# ============================================

List Name Should Not Accept Only Whitespace
    [Documentation]    Nome da lista não deve aceitar apenas espaços
    [Tags]    lists    validation
    Setup Test With Authenticated User
    Click FAB To Create List
    Enter List Name    ${SPACE}${SPACE}${SPACE}
    Verify Submit Button Is Disabled

List Name Should Trim Whitespace
    [Documentation]    Nome da lista deve remover espaços extras
    [Tags]    lists    validation
    Setup Test With Authenticated User
    Click FAB To Create List
    Enter List Name    ${SPACE}${TEST_LIST_NAME}${SPACE}
    Click Submit On List Form
    Verify List Exists With Name    ${TEST_LIST_NAME}

# ============================================
# Testes de Múltiplas Listas
# ============================================

User Should Be Able To Create Multiple Lists
    [Documentation]    Usuário deve poder criar várias listas
    [Tags]    lists    create    multiple
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Create New List    ${TEST_LIST_NAME_2}
    Verify List Count    2
    Verify List Exists With Name    ${TEST_LIST_NAME}
    Verify List Exists With Name    ${TEST_LIST_NAME_2}

Lists Should Maintain Order After Operations
    [Documentation]    Listas devem manter ordem após operações
    [Tags]    lists    order
    Setup Test With Authenticated User
    Create New List    Lista A
    Create New List    Lista B
    Create New List    Lista C
    Delete List    Lista B
    Verify List Count    2
    Verify List Exists With Name    Lista A
    Verify List Exists With Name    Lista C
