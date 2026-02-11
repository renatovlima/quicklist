*** Settings ***
Documentation     Page Object para ShoppingModeScreen
Resource          ../common.resource

*** Variables ***
# Locators - Screen
${SHOPPING_MODE_SCREEN}         css:[data-testid="shopping-mode-screen"]
${SHOPPING_MODE_HEADER}         css:[data-testid="header"]
${SHOPPING_MODE_TITLE}          css:[data-testid="header-title"]
${SHOPPING_MODE_BACK}           css:[data-testid="back-button"]

# Locators - Progress
${PROGRESS_BAR}                 css:[data-testid="progress-bar"]
${PROGRESS_FILL}                css:[data-testid="progress-fill"]
${PROGRESS_TEXT}                css:[data-testid="progress-text"]

# Locators - Sections
${PENDING_SECTION}              css:[data-testid="pending-section"]
${PENDING_SECTION_TITLE}        css:[data-testid="pending-section-title"]
${PENDING_ITEMS_LIST}           css:[data-testid="pending-items-list"]
${BOUGHT_SECTION}               css:[data-testid="bought-section"]
${BOUGHT_SECTION_TITLE}         css:[data-testid="bought-section-title"]
${BOUGHT_ITEMS_LIST}            css:[data-testid="bought-items-list"]

# Locators - Items
${SHOPPING_ITEM}                css:[data-testid="shopping-item"]
${SHOPPING_ITEM_PENDING}        css:[data-testid="shopping-item-pending"]
${SHOPPING_ITEM_BOUGHT}         css:[data-testid="shopping-item-bought"]
${SHOPPING_ITEM_NAME}           css:[data-testid="shopping-item-name"]
${SHOPPING_ITEM_CHECKBOX}       css:[data-testid="shopping-item-checkbox"]

# Locators - Empty State
${SHOPPING_EMPTY_STATE}         css:[data-testid="shopping-empty-state"]

# Locators - Buy Modal
${BUY_MODAL}                    css:[data-testid="buy-modal"]
${BUY_MODAL_PRICE_INPUT}        css:[data-testid="buy-modal-price-input"]
${BUY_MODAL_MARKET_INPUT}       css:[data-testid="buy-modal-market-input"]
${BUY_MODAL_CONFIRM}            css:[data-testid="buy-modal-confirm"]
${BUY_MODAL_CONFIRM_NO_PRICE}   css:[data-testid="buy-modal-confirm-no-price"]

*** Keywords ***
# ============================================
# Verificações de Tela
# ============================================

Verify Shopping Mode Screen Is Displayed
    [Documentation]    Verifica se a tela de modo compra está exibida
    Wait Until Element Is Visible    ${SHOPPING_MODE_SCREEN}    ${TIMEOUT}
    Element Should Be Visible    ${SHOPPING_MODE_HEADER}

Verify Shopping Mode Title
    [Documentation]    Verifica título do modo compra
    Element Should Contain Text    ${SHOPPING_MODE_TITLE}    Modo Compra

Verify Back Button Is Displayed
    [Documentation]    Verifica se botão voltar está visível
    Element Should Be Visible    ${SHOPPING_MODE_BACK}

Verify Empty State Is Displayed
    [Documentation]    Verifica se estado vazio está exibido
    Wait Until Element Is Visible    ${SHOPPING_EMPTY_STATE}    ${TIMEOUT}

# ============================================
# Progress Bar
# ============================================

Verify Progress Bar Is Displayed
    [Documentation]    Verifica se barra de progresso está visível
    Element Should Be Visible    ${PROGRESS_BAR}

Verify Progress Text
    [Documentation]    Verifica texto de progresso
    [Arguments]    ${bought}    ${total}
    ${expected}=    Set Variable    ${bought}/${total}
    Element Should Contain    ${PROGRESS_TEXT}    ${expected}

Get Progress Width
    [Documentation]    Obtém largura da barra de progresso
    ${style}=    Get Element Attribute    ${PROGRESS_FILL}    style
    RETURN    ${style}

# ============================================
# Seções
# ============================================

Verify Pending Section Is Displayed
    [Documentation]    Verifica se seção de pendentes está visível
    Element Should Be Visible    ${PENDING_SECTION}

Verify Pending Section Title
    [Documentation]    Verifica título da seção de pendentes
    Element Should Contain Text    ${PENDING_SECTION_TITLE}    Pendentes

Verify Bought Section Is Displayed
    [Documentation]    Verifica se seção de comprados está visível
    Element Should Be Visible    ${BOUGHT_SECTION}

Verify Bought Section Title
    [Documentation]    Verifica título da seção de comprados
    Element Should Contain Text    ${BOUGHT_SECTION_TITLE}    Comprados

# ============================================
# Contagem de Itens
# ============================================

Get Pending Items Count
    [Documentation]    Retorna quantidade de itens pendentes
    ${count}=    Get Element Count    ${SHOPPING_ITEM_PENDING}
    RETURN    ${count}

Get Bought Items Count
    [Documentation]    Retorna quantidade de itens comprados
    ${count}=    Get Element Count    ${SHOPPING_ITEM_BOUGHT}
    RETURN    ${count}

Verify Pending Items Count
    [Documentation]    Verifica quantidade de itens pendentes
    [Arguments]    ${expected_count}
    ${count}=    Get Pending Items Count
    Should Be Equal As Integers    ${count}    ${expected_count}

Verify Bought Items Count
    [Documentation]    Verifica quantidade de itens comprados
    [Arguments]    ${expected_count}
    ${count}=    Get Bought Items Count
    Should Be Equal As Integers    ${count}    ${expected_count}

# ============================================
# Verificações de Itens
# ============================================

Get Pending Item By Name
    [Documentation]    Retorna locator do item pendente pelo nome
    [Arguments]    ${item_name}
    ${locator}=    Set Variable    xpath://div[@data-testid="shopping-item-pending" and .//span[contains(text(), "${item_name}")]]
    RETURN    ${locator}

Get Bought Item By Name
    [Documentation]    Retorna locator do item comprado pelo nome
    [Arguments]    ${item_name}
    ${locator}=    Set Variable    xpath://div[@data-testid="shopping-item-bought" and .//span[contains(text(), "${item_name}")]]
    RETURN    ${locator}

Verify Item Is In Pending Section
    [Documentation]    Verifica se item está na seção de pendentes
    [Arguments]    ${item_name}
    ${locator}=    Get Pending Item By Name    ${item_name}
    Element Should Be Visible    ${locator}

Verify Item Is In Bought Section
    [Documentation]    Verifica se item está na seção de comprados
    [Arguments]    ${item_name}
    ${locator}=    Get Bought Item By Name    ${item_name}
    Element Should Be Visible    ${locator}

Verify Item Is Not In Pending Section
    [Documentation]    Verifica se item NÃO está na seção de pendentes
    [Arguments]    ${item_name}
    ${locator}=    Get Pending Item By Name    ${item_name}
    Element Should Not Be Visible    ${locator}

Verify Item Is Not In Bought Section
    [Documentation]    Verifica se item NÃO está na seção de comprados
    [Arguments]    ${item_name}
    ${locator}=    Get Bought Item By Name    ${item_name}
    Element Should Not Be Visible    ${locator}

# ============================================
# Ações em Itens
# ============================================

Click Pending Item
    [Documentation]    Clica em item pendente para marcar como comprado
    [Arguments]    ${item_name}
    ${locator}=    Get Pending Item By Name    ${item_name}
    Click Element When Ready    ${locator}

Click Bought Item
    [Documentation]    Clica em item comprado para desmarcar
    [Arguments]    ${item_name}
    ${locator}=    Get Bought Item By Name    ${item_name}
    Click Element When Ready    ${locator}

# ============================================
# Buy Modal
# ============================================

Verify Buy Modal Is Displayed
    [Documentation]    Verifica se modal de compra está exibido
    Wait Until Element Is Visible    ${BUY_MODAL}    ${TIMEOUT}

Enter Price In Buy Modal
    [Documentation]    Insere preço no modal de compra
    [Arguments]    ${price}
    Input Text When Ready    ${BUY_MODAL_PRICE_INPUT}    ${price}

Enter Market In Buy Modal
    [Documentation]    Insere mercado no modal de compra
    [Arguments]    ${market}
    Input Text When Ready    ${BUY_MODAL_MARKET_INPUT}    ${market}

Confirm Buy With Price
    [Documentation]    Confirma compra com preço
    Click Element When Ready    ${BUY_MODAL_CONFIRM}
    Wait For Modal To Close    ${BUY_MODAL}

Confirm Buy Without Price
    [Documentation]    Confirma compra sem preço
    Click Element When Ready    ${BUY_MODAL_CONFIRM_NO_PRICE}
    Wait For Modal To Close    ${BUY_MODAL}

# ============================================
# Navegação
# ============================================

Click Back Button
    [Documentation]    Clica no botão voltar
    Click Element When Ready    ${SHOPPING_MODE_BACK}

# ============================================
# Fluxos Completos
# ============================================

Mark Item As Bought With Price
    [Documentation]    Marca item como comprado com preço
    [Arguments]    ${item_name}    ${price}    ${market}
    Click Pending Item    ${item_name}
    Verify Buy Modal Is Displayed
    Enter Price In Buy Modal    ${price}
    Enter Market In Buy Modal    ${market}
    Confirm Buy With Price
    Verify Item Is In Bought Section    ${item_name}

Mark Item As Bought Without Price
    [Documentation]    Marca item como comprado sem preço
    [Arguments]    ${item_name}
    Click Pending Item    ${item_name}
    Verify Buy Modal Is Displayed
    Confirm Buy Without Price
    Verify Item Is In Bought Section    ${item_name}

Unmark Item As Bought
    [Documentation]    Desmarca item como comprado
    [Arguments]    ${item_name}
    Click Bought Item    ${item_name}
    Verify Item Is In Pending Section    ${item_name}

Verify All Items Are Pending
    [Documentation]    Verifica se todos os itens estão pendentes
    [Arguments]    @{item_names}
    FOR    ${item}    IN    @{item_names}
        Verify Item Is In Pending Section    ${item}
    END

Verify All Items Are Bought
    [Documentation]    Verifica se todos os itens estão comprados
    [Arguments]    @{item_names}
    FOR    ${item}    IN    @{item_names}
        Verify Item Is In Bought Section    ${item}
    END

Buy All Pending Items
    [Documentation]    Compra todos os itens pendentes
    ${count}=    Get Pending Items Count
    FOR    ${i}    IN RANGE    ${count}
        ${items}=    Get WebElements    ${SHOPPING_ITEM_PENDING}
        Exit For Loop If    ${items} == @{EMPTY}
        Click Element    ${items}[0]
        Verify Buy Modal Is Displayed
        Confirm Buy Without Price
    END

Verify Shopping Complete
    [Documentation]    Verifica se a compra está completa
    Verify Pending Items Count    0
    Verify Progress Text    100%
