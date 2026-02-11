*** Settings ***
Documentation     Testes da tela de Modo Compra do QuickList
...               Cobertura: Exibição, toggle de itens, progresso, navegação
Library           SeleniumLibrary
Resource          ../resources/common.resource
Resource          ../resources/pages/shopping_mode_page.resource
Resource          ../resources/pages/list_detail_page.resource
Resource          ../resources/pages/lists_page.resource

Suite Setup       Log    Iniciando testes de Modo Compra
Suite Teardown    Close All Browsers
Test Teardown     Close Test Browser

*** Test Cases ***
# ============================================
# Testes de Exibição - Elementos Básicos
# ============================================

Shopping Mode Should Display Header
    [Documentation]    Verifica se o header está exibido
    [Tags]    shopping-mode    ui    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Shopping Mode Screen Is Displayed

Shopping Mode Should Display Title
    [Documentation]    Verifica se o título está correto
    [Tags]    shopping-mode    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Shopping Mode Title

Shopping Mode Should Display Back Button
    [Documentation]    Verifica se o botão voltar está visível
    [Tags]    shopping-mode    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Back Button Is Displayed

Shopping Mode Should Display Progress Bar
    [Documentation]    Verifica se a barra de progresso está visível
    [Tags]    shopping-mode    ui
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Progress Bar Is Displayed

# ============================================
# Testes de Seções
# ============================================

Shopping Mode Should Display Pending Section
    [Documentation]    Verifica se a seção de pendentes está visível
    [Tags]    shopping-mode    sections
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Pending Section Is Displayed

Shopping Mode Should Display Bought Section
    [Documentation]    Verifica se a seção de comprados está visível
    [Tags]    shopping-mode    sections
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Bought Section Is Displayed

Pending Section Should Show Correct Title
    [Documentation]    Seção de pendentes deve ter título correto
    [Tags]    shopping-mode    sections
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Pending Section Title

Bought Section Should Show Correct Title
    [Documentation]    Seção de comprados deve ter título correto
    [Tags]    shopping-mode    sections
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Bought Section Title

# ============================================
# Testes de Exibição de Itens
# ============================================

Pending Items Should Be In Pending Section
    [Documentation]    Itens pendentes devem estar na seção correta
    [Tags]    shopping-mode    items
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Item Is In Pending Section    Arroz

Bought Items Should Be In Bought Section
    [Documentation]    Itens comprados devem estar na seção correta
    [Tags]    shopping-mode    items
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Item Is In Bought Section    Feijão

Should Show Correct Pending Items Count
    [Documentation]    Deve mostrar contagem correta de pendentes
    [Tags]    shopping-mode    items    count
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Pending Items Count    1

Should Show Correct Bought Items Count
    [Documentation]    Deve mostrar contagem correta de comprados
    [Tags]    shopping-mode    items    count
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Bought Items Count    1

# ============================================
# Testes de Toggle de Status
# ============================================

Clicking Pending Item Should Open Buy Modal
    [Documentation]    Clicar em item pendente deve abrir modal de compra
    [Tags]    shopping-mode    toggle    modal    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Click Pending Item    Arroz
    Verify Buy Modal Is Displayed

User Should Be Able To Mark Item As Bought With Price
    [Documentation]    Usuário deve poder marcar item com preço
    [Tags]    shopping-mode    toggle    price    smoke
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought With Price    Arroz    ${TEST_PRICE}    ${TEST_MARKET}

User Should Be Able To Mark Item As Bought Without Price
    [Documentation]    Usuário deve poder marcar item sem preço
    [Tags]    shopping-mode    toggle
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought Without Price    Arroz

Item Should Move To Bought Section After Purchase
    [Documentation]    Item deve mover para seção de comprados
    [Tags]    shopping-mode    toggle
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought Without Price    Arroz
    Verify Item Is Not In Pending Section    Arroz
    Verify Item Is In Bought Section    Arroz

User Should Be Able To Unmark Bought Item
    [Documentation]    Usuário deve poder desmarcar item comprado
    [Tags]    shopping-mode    toggle
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Unmark Item As Bought    Feijão
    Verify Item Is Not In Bought Section    Feijão
    Verify Item Is In Pending Section    Feijão

# ============================================
# Testes de Progress Bar
# ============================================

Progress Should Update When Marking Item As Bought
    [Documentation]    Progresso deve atualizar ao marcar item
    [Tags]    shopping-mode    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Progress Text    1    2
    Mark Item As Bought Without Price    Arroz
    Verify Progress Text    2    2

Progress Should Update When Unmarking Item
    [Documentation]    Progresso deve atualizar ao desmarcar item
    [Tags]    shopping-mode    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Verify Progress Text    1    2
    Unmark Item As Bought    Feijão
    Verify Progress Text    0    2

Progress Bar Should Show 100 Percent When All Bought
    [Documentation]    Barra deve mostrar 100% quando todos comprados
    [Tags]    shopping-mode    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought Without Price    Arroz
    # Agora temos 2/2 = 100%
    Verify Progress Text    2    2

Progress Bar Should Show 0 Percent When All Pending
    [Documentation]    Barra deve mostrar 0% quando todos pendentes
    [Tags]    shopping-mode    progress
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Unmark Item As Bought    Feijão
    # Agora temos 0/2 = 0%
    Verify Progress Text    0    2

# ============================================
# Testes de Navegação
# ============================================

Back Button Should Return To List Detail
    [Documentation]    Botão voltar deve retornar para detalhes
    [Tags]    shopping-mode    navigation
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Click Back Button
    Verify List Detail Screen Is Displayed

# ============================================
# Testes de Estado Vazio
# ============================================

Empty List Should Show Empty State
    [Documentation]    Lista vazia deve mostrar estado vazio
    [Tags]    shopping-mode    empty-state
    Setup Test With Authenticated User
    Create New List    Lista Vazia
    Click On List To Open Details    Lista Vazia
    Click Shopping Mode Button
    Verify Empty State Is Displayed

All Items Bought Should Show Empty Pending Section
    [Documentation]    Todos comprados deve esvaziar seção pendentes
    [Tags]    shopping-mode    empty-state
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought Without Price    Arroz
    Verify Pending Items Count    0

All Items Pending Should Show Empty Bought Section
    [Documentation]    Todos pendentes deve esvaziar seção comprados
    [Tags]    shopping-mode    empty-state
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Unmark Item As Bought    Feijão
    Verify Bought Items Count    0

# ============================================
# Testes de Múltiplos Itens
# ============================================

User Should Be Able To Buy All Items
    [Documentation]    Usuário deve poder comprar todos os itens
    [Tags]    shopping-mode    multiple
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Buy All Pending Items
    Verify Pending Items Count    0

# ============================================
# Testes de Buy Modal
# ============================================

Buy Modal Should Show Item Name
    [Documentation]    Modal de compra deve mostrar nome do item
    [Tags]    shopping-mode    modal
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Click Pending Item    Arroz
    Verify Buy Modal Is Displayed
    Page Should Contain    Arroz

Buy Modal Should Accept Price Input
    [Documentation]    Modal deve aceitar input de preço
    [Tags]    shopping-mode    modal    price
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Click Pending Item    Arroz
    Verify Buy Modal Is Displayed
    Enter Price In Buy Modal    ${TEST_PRICE}
    ${value}=    Get Value    ${BUY_MODAL_PRICE_INPUT}
    Should Be Equal    ${value}    ${TEST_PRICE}

Buy Modal Should Accept Market Input
    [Documentation]    Modal deve aceitar input de mercado
    [Tags]    shopping-mode    modal    market
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Click Pending Item    Arroz
    Verify Buy Modal Is Displayed
    Enter Market In Buy Modal    ${TEST_MARKET}
    ${value}=    Get Value    ${BUY_MODAL_MARKET_INPUT}
    Should Be Equal    ${value}    ${TEST_MARKET}

# ============================================
# Testes de Sincronização com List Detail
# ============================================

Changes In Shopping Mode Should Reflect In List Detail
    [Documentation]    Mudanças devem refletir em detalhes da lista
    [Tags]    shopping-mode    sync
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    Mark Item As Bought Without Price    Arroz
    Click Back Button
    # Verificar que o item está marcado como comprado
    Verify Progress Text    2    2

# ============================================
# Testes de Visual Feedback
# ============================================

Bought Items Should Have Visual Distinction
    [Documentation]    Itens comprados devem ter distinção visual
    [Tags]    shopping-mode    visual
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    # Itens comprados devem ter opacity reduzida ou strikethrough
    ${bought_item}=    Get Bought Item By Name    Feijão
    Element Should Be Visible    ${bought_item}

Pending Items Should Be Clearly Visible
    [Documentation]    Itens pendentes devem estar claramente visíveis
    [Tags]    shopping-mode    visual
    Setup Test With Sample Data
    Click On List To Open Details    Lista de Compras
    Click Shopping Mode Button
    ${pending_item}=    Get Pending Item By Name    Arroz
    Element Should Be Visible    ${pending_item}
