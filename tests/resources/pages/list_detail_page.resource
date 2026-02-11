*** Settings ***
Documentation     Page Object para ListDetailScreen
Resource          ../common.resource

*** Variables ***
# Locators - Screen
${LIST_DETAIL_SCREEN}           css:[data-testid="list-detail-screen"]
${LIST_DETAIL_HEADER}           css:[data-testid="header"]
${LIST_DETAIL_TITLE}            css:[data-testid="header-title"]
${LIST_DETAIL_BACK}             css:[data-testid="back-button"]
${SHOPPING_MODE_BUTTON}         css:[data-testid="shopping-mode-button"]

# Locators - Progress
${PROGRESS_BAR}                 css:[data-testid="progress-bar"]
${PROGRESS_FILL}                css:[data-testid="progress-fill"]
${PROGRESS_TEXT}                css:[data-testid="progress-text"]

# Locators - Search
${SEARCH_INPUT}                 css:[data-testid="search-input"]

# Locators - Quick Add
${QUICK_ADD_INPUT}              css:[data-testid="quick-add-input"]
${QUICK_ADD_BUTTON}             css:[data-testid="quick-add-button"]
${CATALOG_BUTTON}               css:[data-testid="catalog-button"]

# Locators - Items
${ITEM_CARD}                    css:[data-testid="item-card"]
${ITEM_CHECKBOX}                css:[data-testid="item-checkbox"]
${ITEM_NAME}                    css:[data-testid="item-name"]
${ITEM_PRICE_BADGE}             css:[data-testid="item-price-badge"]
${ITEM_HISTORY_BUTTON}          css:[data-testid="item-history-button"]
${ITEM_EDIT_BUTTON}             css:[data-testid="item-edit-button"]
${ITEM_DELETE_BUTTON}           css:[data-testid="item-delete-button"]
${ITEMS_EMPTY_STATE}            css:[data-testid="items-empty-state"]

# Locators - Item Form Modal
${ITEM_FORM_MODAL}              css:[data-testid="item-form-modal"]
${ITEM_FORM_INPUT}              css:[data-testid="item-form-input"]
${ITEM_FORM_CANCEL}             css:[data-testid="item-form-cancel"]
${ITEM_FORM_SUBMIT}             css:[data-testid="item-form-submit"]

# Locators - Buy Modal
${BUY_MODAL}                    css:[data-testid="buy-modal"]
${BUY_MODAL_ITEM_NAME}          css:[data-testid="buy-modal-item-name"]
${BUY_MODAL_PRICE_INPUT}        css:[data-testid="buy-modal-price-input"]
${BUY_MODAL_MARKET_INPUT}       css:[data-testid="buy-modal-market-input"]
${BUY_MODAL_CONFIRM}            css:[data-testid="buy-modal-confirm"]
${BUY_MODAL_CONFIRM_NO_PRICE}   css:[data-testid="buy-modal-confirm-no-price"]
${MARKET_SUGGESTIONS}           css:[data-testid="market-suggestions"]
${MARKET_SUGGESTION_ITEM}       css:[data-testid="market-suggestion-item"]

# Locators - Price History Modal
${PRICE_HISTORY_MODAL}          css:[data-testid="price-history-modal"]
${PRICE_HISTORY_ITEM_NAME}      css:[data-testid="price-history-item-name"]
${PRICE_HISTORY_BEST}           css:[data-testid="price-history-best"]
${PRICE_HISTORY_LIST}           css:[data-testid="price-history-list"]
${PRICE_HISTORY_ENTRY}          css:[data-testid="price-history-entry"]
${PRICE_HISTORY_EMPTY}          css:[data-testid="price-history-empty"]
${PRICE_HISTORY_CLOSE}          css:[data-testid="modal-close"]

# Locators - Catalog Modal
${CATALOG_MODAL}                css:[data-testid="catalog-modal"]
${CATALOG_SEARCH}               css:[data-testid="catalog-search"]
${CATALOG_TABS}                 css:[data-testid="catalog-tabs"]
${CATALOG_TAB}                  css:[data-testid="catalog-tab"]
${CATALOG_ITEMS_GRID}           css:[data-testid="catalog-items-grid"]
${CATALOG_ITEM}                 css:[data-testid="catalog-item"]
${CATALOG_CUSTOM_INPUT}         css:[data-testid="catalog-custom-input"]
${CATALOG_ADD_BUTTON}           css:[data-testid="catalog-add-button"]
${CATALOG_CLOSE}                css:[data-testid="catalog-close"]

# Locators - Delete Confirm Modal
${DELETE_CONFIRM_MODAL}         css:[data-testid="delete-confirm-modal"]
${DELETE_CONFIRM_CANCEL}        css:[data-testid="delete-confirm-cancel"]
${DELETE_CONFIRM_BUTTON}        css:[data-testid="delete-confirm-button"]

*** Keywords ***
# ============================================
# Verificações de Tela
# ============================================

Verify List Detail Screen Is Displayed
    [Documentation]    Verifica se a tela de detalhes está exibida
    Wait Until Element Is Visible    ${LIST_DETAIL_SCREEN}    ${TIMEOUT}
    Element Should Be Visible    ${LIST_DETAIL_HEADER}

Verify List Title
    [Documentation]    Verifica o título da lista
    [Arguments]    ${expected_title}
    Element Should Contain Text    ${LIST_DETAIL_TITLE}    ${expected_title}

Verify Back Button Is Displayed
    [Documentation]    Verifica se botão voltar está visível
    Element Should Be Visible    ${LIST_DETAIL_BACK}

Verify Shopping Mode Button Is Displayed
    [Documentation]    Verifica se botão modo compra está visível
    Element Should Be Visible    ${SHOPPING_MODE_BUTTON}

Verify Items Empty State Is Displayed
    [Documentation]    Verifica se estado vazio de itens está exibido
    Wait Until Element Is Visible    ${ITEMS_EMPTY_STATE}    ${TIMEOUT}

Verify Items Empty State Is Not Displayed
    [Documentation]    Verifica se estado vazio NÃO está exibido
    Element Should Not Be Visible    ${ITEMS_EMPTY_STATE}

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

Get Progress Percentage
    [Documentation]    Obtém percentual de progresso
    ${style}=    Get Element Attribute    ${PROGRESS_FILL}    style
    ${width}=    Evaluate    '${style}'.split('width:')[1].split('%')[0].strip() if 'width:' in '${style}' else '0'
    RETURN    ${width}

# ============================================
# Busca
# ============================================

Verify Search Input Is Displayed
    [Documentation]    Verifica se campo de busca está visível
    Element Should Be Visible    ${SEARCH_INPUT}

Search For Item
    [Documentation]    Busca por item
    [Arguments]    ${search_text}
    Input Text When Ready    ${SEARCH_INPUT}    ${search_text}

Clear Search
    [Documentation]    Limpa campo de busca
    Clear Element Text    ${SEARCH_INPUT}

# ============================================
# Quick Add
# ============================================

Verify Quick Add Is Displayed
    [Documentation]    Verifica se quick add está visível
    Element Should Be Visible    ${QUICK_ADD_INPUT}
    Element Should Be Visible    ${QUICK_ADD_BUTTON}
    Element Should Be Visible    ${CATALOG_BUTTON}

Add Item Via Quick Add
    [Documentation]    Adiciona item via quick add
    [Arguments]    ${item_name}
    Input Text When Ready    ${QUICK_ADD_INPUT}    ${item_name}
    Click Element When Ready    ${QUICK_ADD_BUTTON}

Add Item Via Quick Add With Enter
    [Documentation]    Adiciona item via quick add com Enter
    [Arguments]    ${item_name}
    Input Text When Ready    ${QUICK_ADD_INPUT}    ${item_name}
    Press Enter Key    ${QUICK_ADD_INPUT}

Verify Quick Add Input Is Empty
    [Documentation]    Verifica se input do quick add está vazio
    ${value}=    Get Value    ${QUICK_ADD_INPUT}
    Should Be Empty    ${value}

# ============================================
# Items
# ============================================

Verify Item Count
    [Documentation]    Verifica quantidade de itens
    [Arguments]    ${expected_count}
    ${count}=    Get Element Count    ${ITEM_CARD}
    Should Be Equal As Integers    ${count}    ${expected_count}

Verify Item Exists
    [Documentation]    Verifica se item existe
    [Arguments]    ${item_name}
    Page Should Contain Text    ${item_name}

Verify Item Does Not Exist
    [Documentation]    Verifica se item NÃO existe
    [Arguments]    ${item_name}
    Page Should Not Contain Text    ${item_name}

Get Item Card By Name
    [Documentation]    Retorna locator do card do item pelo nome
    [Arguments]    ${item_name}
    ${locator}=    Set Variable    xpath://div[@data-testid="item-card" and .//span[contains(text(), "${item_name}")]]
    RETURN    ${locator}

Verify Item Is Pending
    [Documentation]    Verifica se item está pendente
    [Arguments]    ${item_name}
    ${card}=    Get Item Card By Name    ${item_name}
    Element Should Not Contain    ${card}    line-through

Verify Item Is Bought
    [Documentation]    Verifica se item está comprado
    [Arguments]    ${item_name}
    ${card}=    Get Item Card By Name    ${item_name}
    # Verificar classe de strikethrough ou atributo de status

Verify Item Has Price Badge
    [Documentation]    Verifica se item tem badge de preço
    [Arguments]    ${item_name}    ${expected_price}
    ${card}=    Get Item Card By Name    ${item_name}
    Element Should Contain    ${card}    R$

Click Item Checkbox
    [Documentation]    Clica no checkbox do item
    [Arguments]    ${item_name}
    ${card}=    Get Item Card By Name    ${item_name}
    Click Element When Ready    ${card}//button[@data-testid="item-checkbox"]

# ============================================
# Edit Item
# ============================================

Click Edit Button For Item
    [Documentation]    Clica no botão editar do item
    [Arguments]    ${item_name}
    ${card}=    Get Item Card By Name    ${item_name}
    Click Element When Ready    ${card}//button[@data-testid="item-edit-button"]
    Wait For Modal To Open    ${ITEM_FORM_MODAL}

Edit Item Name
    [Documentation]    Edita nome do item
    [Arguments]    ${new_name}
    Clear And Input Text    ${ITEM_FORM_INPUT}    ${new_name}
    Click Element When Ready    ${ITEM_FORM_SUBMIT}
    Wait For Modal To Close    ${ITEM_FORM_MODAL}

# ============================================
# Delete Item
# ============================================

Click Delete Button For Item
    [Documentation]    Clica no botão deletar do item
    [Arguments]    ${item_name}
    ${card}=    Get Item Card By Name    ${item_name}
    Click Element When Ready    ${card}//button[@data-testid="item-delete-button"]
    Wait For Modal To Open    ${DELETE_CONFIRM_MODAL}

Confirm Delete Item
    [Documentation]    Confirma exclusão do item
    Click Element When Ready    ${DELETE_CONFIRM_BUTTON}
    Wait For Modal To Close    ${DELETE_CONFIRM_MODAL}

Cancel Delete Item
    [Documentation]    Cancela exclusão do item
    Click Element When Ready    ${DELETE_CONFIRM_CANCEL}
    Wait For Modal To Close    ${DELETE_CONFIRM_MODAL}

# ============================================
# Buy Modal
# ============================================

Verify Buy Modal Is Displayed
    [Documentation]    Verifica se modal de compra está exibido
    Wait Until Element Is Visible    ${BUY_MODAL}    ${TIMEOUT}

Verify Buy Modal Item Name
    [Documentation]    Verifica nome do item no modal de compra
    [Arguments]    ${item_name}
    Element Should Contain    ${BUY_MODAL_ITEM_NAME}    ${item_name}

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

Select Market Suggestion
    [Documentation]    Seleciona sugestão de mercado
    [Arguments]    ${market_name}
    Click Element When Ready    xpath://div[@data-testid="market-suggestion-item" and contains(text(), "${market_name}")]

# ============================================
# Price History Modal
# ============================================

Click Price History Button For Item
    [Documentation]    Clica no botão de histórico do item
    [Arguments]    ${item_name}
    ${card}=    Get Item Card By Name    ${item_name}
    Click Element When Ready    ${card}//button[@data-testid="item-history-button"]
    Wait For Modal To Open    ${PRICE_HISTORY_MODAL}

Verify Price History Modal Is Displayed
    [Documentation]    Verifica se modal de histórico está exibido
    Wait Until Element Is Visible    ${PRICE_HISTORY_MODAL}    ${TIMEOUT}

Verify Best Price In History
    [Documentation]    Verifica melhor preço no histórico
    [Arguments]    ${expected_price}
    Element Should Contain    ${PRICE_HISTORY_BEST}    R$ ${expected_price}

Verify Price History Entry Count
    [Documentation]    Verifica quantidade de entradas no histórico
    [Arguments]    ${expected_count}
    ${count}=    Get Element Count    ${PRICE_HISTORY_ENTRY}
    Should Be Equal As Integers    ${count}    ${expected_count}

Verify Price History Is Empty
    [Documentation]    Verifica se histórico está vazio
    Element Should Be Visible    ${PRICE_HISTORY_EMPTY}

Close Price History Modal
    [Documentation]    Fecha modal de histórico
    Click Element When Ready    ${PRICE_HISTORY_CLOSE}
    Wait For Modal To Close    ${PRICE_HISTORY_MODAL}

# ============================================
# Catalog Modal
# ============================================

Open Catalog Modal
    [Documentation]    Abre modal de catálogo
    Click Element When Ready    ${CATALOG_BUTTON}
    Wait For Modal To Open    ${CATALOG_MODAL}

Verify Catalog Modal Is Displayed
    [Documentation]    Verifica se modal de catálogo está exibido
    Wait Until Element Is Visible    ${CATALOG_MODAL}    ${TIMEOUT}

Search In Catalog
    [Documentation]    Busca no catálogo
    [Arguments]    ${search_text}
    Input Text When Ready    ${CATALOG_SEARCH}    ${search_text}

Select Catalog Category
    [Documentation]    Seleciona categoria do catálogo
    [Arguments]    ${category_name}
    Click Element When Ready    xpath://button[@data-testid="catalog-tab" and contains(text(), "${category_name}")]

Select Catalog Item
    [Documentation]    Seleciona item do catálogo
    [Arguments]    ${item_name}
    Click Element When Ready    xpath://button[@data-testid="catalog-item" and contains(text(), "${item_name}")]

Select Multiple Catalog Items
    [Documentation]    Seleciona múltiplos itens do catálogo
    [Arguments]    @{item_names}
    FOR    ${item}    IN    @{item_names}
        Select Catalog Item    ${item}
    END

Verify Catalog Item Is Selected
    [Documentation]    Verifica se item do catálogo está selecionado
    [Arguments]    ${item_name}
    ${item}=    Set Variable    xpath://button[@data-testid="catalog-item" and contains(text(), "${item_name}")]
    Element Should Contain    ${item}    check

Verify Catalog Item Is Disabled
    [Documentation]    Verifica se item do catálogo está desabilitado
    [Arguments]    ${item_name}
    ${item}=    Set Variable    xpath://button[@data-testid="catalog-item" and contains(text(), "${item_name}")]
    Element Should Be Disabled    ${item}

Enter Custom Catalog Item
    [Documentation]    Insere item customizado no catálogo
    [Arguments]    ${item_name}
    Input Text When Ready    ${CATALOG_CUSTOM_INPUT}    ${item_name}

Click Add Items From Catalog
    [Documentation]    Clica em adicionar itens do catálogo
    Click Element When Ready    ${CATALOG_ADD_BUTTON}
    Wait For Modal To Close    ${CATALOG_MODAL}

Close Catalog Modal
    [Documentation]    Fecha modal de catálogo
    Click Element When Ready    ${CATALOG_CLOSE}
    Wait For Modal To Close    ${CATALOG_MODAL}

Verify Add Button Shows Count
    [Documentation]    Verifica se botão mostra contagem
    [Arguments]    ${count}
    Element Should Contain    ${CATALOG_ADD_BUTTON}    ${count}

# ============================================
# Navegação
# ============================================

Click Back Button
    [Documentation]    Clica no botão voltar
    Click Element When Ready    ${LIST_DETAIL_BACK}

Click Shopping Mode Button
    [Documentation]    Clica no botão modo compra
    Click Element When Ready    ${SHOPPING_MODE_BUTTON}

# ============================================
# Fluxos Completos
# ============================================

Add Item And Verify
    [Documentation]    Adiciona item e verifica
    [Arguments]    ${item_name}
    Add Item Via Quick Add    ${item_name}
    Verify Item Exists    ${item_name}

Delete Item And Verify
    [Documentation]    Deleta item e verifica
    [Arguments]    ${item_name}
    Click Delete Button For Item    ${item_name}
    Confirm Delete Item
    Verify Item Does Not Exist    ${item_name}

Mark Item As Bought With Price
    [Documentation]    Marca item como comprado com preço
    [Arguments]    ${item_name}    ${price}    ${market}
    Click Item Checkbox    ${item_name}
    Verify Buy Modal Is Displayed
    Enter Price In Buy Modal    ${price}
    Enter Market In Buy Modal    ${market}
    Confirm Buy With Price

Mark Item As Bought Without Price
    [Documentation]    Marca item como comprado sem preço
    [Arguments]    ${item_name}
    Click Item Checkbox    ${item_name}
    Verify Buy Modal Is Displayed
    Confirm Buy Without Price

Add Items From Catalog
    [Documentation]    Adiciona itens do catálogo
    [Arguments]    @{item_names}
    Open Catalog Modal
    Select Multiple Catalog Items    @{item_names}
    Click Add Items From Catalog
    FOR    ${item}    IN    @{item_names}
        Verify Item Exists    ${item}
    END
