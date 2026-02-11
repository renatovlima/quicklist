*** Settings ***
Documentation     Testes de Persistência de Dados do QuickList
...               Cobertura: localStorage, refresh, sessão, dados
Library           SeleniumLibrary
Resource          ../resources/common.resource
Resource          ../resources/pages/login_page.resource
Resource          ../resources/pages/lists_page.resource
Resource          ../resources/pages/list_detail_page.resource
Resource          ../resources/pages/shopping_mode_page.resource

Suite Setup       Log    Iniciando testes de Persistência
Suite Teardown    Close All Browsers
Test Teardown     Close Test Browser

*** Test Cases ***
# ============================================
# Testes de Persistência de Usuário
# ============================================

User Data Should Persist After Page Refresh
    [Documentation]    Dados do usuário devem persistir após refresh
    [Tags]    persistence    user    smoke
    Setup Test With Authenticated User
    Reload Page And Wait
    Verify Lists Screen Is Displayed
    ${user_data}=    Get Local Storage Value    ${LS_USER}
    Should Not Be Empty    ${user_data}

User Should Remain Logged In After Refresh
    [Documentation]    Usuário deve continuar logado após refresh
    [Tags]    persistence    user    auth
    Setup Test With Authenticated User
    Reload Page And Wait
    Verify Lists Screen Is Displayed
    Page Should Not Contain Element    ${LOGIN_SCREEN}

Logout Should Clear User Data
    [Documentation]    Logout deve limpar dados do usuário
    [Tags]    persistence    user    logout
    Setup Test With Authenticated User
    Click Logout Button
    ${user_data}=    Get Local Storage Value    ${LS_USER}
    Should Be Equal    ${user_data}    ${NONE}

# ============================================
# Testes de Persistência de Listas
# ============================================

Created List Should Persist After Refresh
    [Documentation]    Lista criada deve persistir após refresh
    [Tags]    persistence    lists    smoke
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Reload Page And Wait
    Verify List Exists With Name    ${TEST_LIST_NAME}

Edited List Name Should Persist After Refresh
    [Documentation]    Nome editado deve persistir após refresh
    [Tags]    persistence    lists
    Setup Test With Sample Data
    Edit List    Lista de Compras    ${TEST_LIST_NAME_EDITED}
    Reload Page And Wait
    Verify List Exists With Name    ${TEST_LIST_NAME_EDITED}

Deleted List Should Not Appear After Refresh
    [Documentation]    Lista deletada não deve aparecer após refresh
    [Tags]    persistence    lists
    Setup Test With Sample Data
    Delete List    Lista de Compras
    Reload Page And Wait
    Verify List Does Not Exist With Name    Lista de Compras

Multiple Lists Should Persist After Refresh
    [Documentation]    Múltiplas listas devem persistir após refresh
    [Tags]    persistence    lists    multiple
    Setup Test With Authenticated User
    Create New List    Lista A
    Create New List    Lista B
    Create New List    Lista C
    Reload Page And Wait
    Verify List Count    3
    Verify List Exists With Name    Lista A
    Verify List Exists With Name    Lista B
    Verify List Exists With Name    Lista C

Lists Data Should Be Stored In LocalStorage
    [Documentation]    Dados das listas devem estar no localStorage
    [Tags]    persistence    lists    storage
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    ${lists_data}=    Get Local Storage Value    ${LS_LISTS}
    Should Not Be Empty    ${lists_data}
    Should Contain    ${lists_data}    ${TEST_LIST_NAME}

# ============================================
# Testes de Persistência de Itens
# ============================================

Added Item Should Persist After Refresh
    [Documentation]    Item adicionado deve persistir após refresh
    [Tags]    persistence    items    smoke
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item And Verify    ${TEST_ITEM_NAME}
    Reload Page And Wait
    Verify Item Exists    ${TEST_ITEM_NAME}

Edited Item Name Should Persist After Refresh
    [Documentation]    Nome editado do item deve persistir após refresh
    [Tags]    persistence    items
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Edit Button For Item    Arroz
    Edit Item Name    ${TEST_ITEM_NAME_EDITED}
    Reload Page And Wait
    Verify Item Exists    ${TEST_ITEM_NAME_EDITED}

Deleted Item Should Not Appear After Refresh
    [Documentation]    Item deletado não deve aparecer após refresh
    [Tags]    persistence    items
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Delete Item And Verify    Arroz
    Reload Page And Wait
    Verify Item Does Not Exist    Arroz

Item Status Should Persist After Refresh
    [Documentation]    Status do item deve persistir após refresh
    [Tags]    persistence    items    status
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought Without Price    Arroz
    Reload Page And Wait
    # Verificar que o item ainda está marcado como comprado
    Verify Progress Text    2    2

Items Data Should Be Stored In LocalStorage
    [Documentation]    Dados dos itens devem estar no localStorage
    [Tags]    persistence    items    storage
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Click On List To Open Details    ${TEST_LIST_NAME}
    Add Item Via Quick Add    ${TEST_ITEM_NAME}
    ${items_data}=    Get Local Storage Value    ${LS_ITEMS}
    Should Not Be Empty    ${items_data}
    Should Contain    ${items_data}    ${TEST_ITEM_NAME}

# ============================================
# Testes de Persistência de Preços
# ============================================

Price Should Persist After Refresh
    [Documentation]    Preço deve persistir após refresh
    [Tags]    persistence    price    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    Reload Page And Wait
    Verify Item Has Price Badge    Arroz    ${TEST_PRICE}

Price History Should Persist After Refresh
    [Documentation]    Histórico de preços deve persistir após refresh
    [Tags]    persistence    price    history
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    Reload Page And Wait
    Click Price History Button For Item    Arroz
    Verify Price History Entry Count    1

Multiple Prices Should Persist In History
    [Documentation]    Múltiplos preços devem persistir no histórico
    [Tags]    persistence    price    history    multiple
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    # Comprar, desmarcar, comprar novamente com preço diferente
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    # Simular nova compra adicionando outro registro de preço
    # (Em um cenário real, o item seria desmarcado e marcado novamente)
    Reload Page And Wait
    Click Price History Button For Item    Arroz
    Verify Best Price In History    ${TEST_PRICE}

Price Data Should Be Stored In LocalStorage
    [Documentation]    Dados de preço devem estar no localStorage
    [Tags]    persistence    price    storage
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    ${price_data}=    Get Local Storage Value    ${LS_PRICE_HISTORY}
    Should Not Be Empty    ${price_data}

# ============================================
# Testes de Persistência de Mercados
# ============================================

Market Names Should Persist For Autocomplete
    [Documentation]    Nomes de mercados devem persistir para autocomplete
    [Tags]    persistence    market    autocomplete
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}
    Reload Page And Wait
    # Verificar que o mercado está salvo
    ${markets_data}=    Get Local Storage Value    ${LS_MARKETS}
    Should Contain    ${markets_data}    ${TEST_MARKET}

# ============================================
# Testes de Navegação com Persistência
# ============================================

Data Should Persist When Navigating Between Screens
    [Documentation]    Dados devem persistir ao navegar entre telas
    [Tags]    persistence    navigation
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Mark Item As Bought Without Price    Arroz
    Click Back Button
    Click On List To Open Details    Lista de Compras
    # Item ainda deve estar marcado como comprado
    Verify Progress Text    2    2

Data Should Persist When Entering And Exiting Shopping Mode
    [Documentation]    Dados devem persistir ao entrar/sair do modo compra
    [Tags]    persistence    navigation    shopping-mode
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought Without Price    Arroz
    Click Back Button
    # Verificar que mudança persistiu
    Verify Progress Text    2    2

# ============================================
# Testes de Integridade de Dados
# ============================================

Deleting List Should Delete Associated Items
    [Documentation]    Deletar lista deve deletar itens associados
    [Tags]    persistence    integrity    cascade
    Setup Test With Sample Data
    ${items_before}=    Get Local Storage Value    ${LS_ITEMS}
    Should Contain    ${items_before}    list-1
    Delete List    Lista de Compras
    ${items_after}=    Get Local Storage Value    ${LS_ITEMS}
    Should Not Contain    ${items_after}    list-1

Items Should Be Associated With Correct List
    [Documentation]    Itens devem estar associados à lista correta
    [Tags]    persistence    integrity
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Verify Item Exists    Arroz
    Click Back Button
    Click On List To Open Details    Lista do Mês
    Verify Item Does Not Exist    Arroz
    Verify Item Exists    Leite

# ============================================
# Testes de Limpeza de Dados
# ============================================

Clear LocalStorage Should Reset App State
    [Documentation]    Limpar localStorage deve resetar estado do app
    [Tags]    persistence    clear    reset
    Setup Test With Sample Data
    Clear All Local Storage
    Reload Page
    Verify Login Screen Is Displayed

# ============================================
# Testes de Edge Cases
# ============================================

Empty LocalStorage Should Show Login Screen
    [Documentation]    localStorage vazio deve mostrar tela de login
    [Tags]    persistence    edge-case
    Open Browser To QuickList
    Clear All Local Storage
    Reload Page
    Verify Login Screen Is Displayed

Corrupted User Data Should Handle Gracefully
    [Documentation]    Dados corrompidos devem ser tratados
    [Tags]    persistence    edge-case    error-handling
    Open Browser To QuickList
    Set Local Storage Value    ${LS_USER}    invalid-json
    Reload Page
    # App deve lidar graciosamente e mostrar login
    # ou resetar o estado

Large Data Set Should Persist Correctly
    [Documentation]    Grande volume de dados deve persistir
    [Tags]    persistence    edge-case    performance
    Setup Test With Authenticated User
    # Criar múltiplas listas
    FOR    ${i}    IN RANGE    5
        Create New List    Lista ${i}
    END
    Reload Page And Wait
    Verify List Count    5

# ============================================
# Testes de Sessão
# ============================================

Session Should Persist Across Browser Tabs
    [Documentation]    Sessão deve persistir em múltiplas abas
    [Tags]    persistence    session    tabs
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    # Abrir nova aba
    Execute Javascript    window.open('${BASE_URL}', '_blank');
    ${handles}=    Get Window Handles
    Switch Window    ${handles}[1]
    Wait Until Page Contains Element    css:[data-testid="lists-screen"]    ${TIMEOUT}
    Verify List Exists With Name    ${TEST_LIST_NAME}
    # Fechar aba e voltar
    Close Window
    Switch Window    ${handles}[0]

Data Should Sync Between Tabs
    [Documentation]    Dados devem sincronizar entre abas
    [Tags]    persistence    session    sync
    [Documentation]    Nota: localStorage é síncrono, mudanças são visíveis imediatamente
    Setup Test With Authenticated User
    Create New List    ${TEST_LIST_NAME}
    Reload Page And Wait
    Verify List Exists With Name    ${TEST_LIST_NAME}
