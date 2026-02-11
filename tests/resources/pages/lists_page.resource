*** Settings ***
Documentation     Page Object para ListsScreen
Resource          ../common.resource

*** Variables ***
# Locators - Screen
${LISTS_SCREEN}                 css:[data-testid="lists-screen"]
${LISTS_HEADER}                 css:[data-testid="header"]
${LISTS_HEADER_TITLE}           css:[data-testid="header-title"]
${LISTS_LOGOUT_BUTTON}          css:[data-testid="logout-button"]
${LISTS_EMPTY_STATE}            css:[data-testid="empty-state"]
${LISTS_FAB}                    css:[data-testid="fab-add-list"]

# Locators - List Cards
${LIST_CARD}                    css:[data-testid="list-card"]
${LIST_CARD_NAME}               css:[data-testid="list-card-name"]
${LIST_CARD_PROGRESS}           css:[data-testid="list-card-progress"]
${LIST_CARD_EDIT}               css:[data-testid="list-card-edit"]
${LIST_CARD_DELETE}             css:[data-testid="list-card-delete"]

# Locators - List Form Modal
${LIST_FORM_MODAL}              css:[data-testid="list-form-modal"]
${LIST_FORM_INPUT}              css:[data-testid="list-form-input"]
${LIST_FORM_CANCEL}             css:[data-testid="list-form-cancel"]
${LIST_FORM_SUBMIT}             css:[data-testid="list-form-submit"]

# Locators - Delete Confirm Modal
${DELETE_CONFIRM_MODAL}         css:[data-testid="delete-confirm-modal"]
${DELETE_CONFIRM_MESSAGE}       css:[data-testid="delete-confirm-message"]
${DELETE_CONFIRM_CANCEL}        css:[data-testid="delete-confirm-cancel"]
${DELETE_CONFIRM_BUTTON}        css:[data-testid="delete-confirm-button"]

*** Keywords ***
# ============================================
# Verificações de Tela
# ============================================

Verify Lists Screen Is Displayed
    [Documentation]    Verifica se a tela de listas está exibida
    Wait Until Element Is Visible    ${LISTS_SCREEN}    ${TIMEOUT}
    Element Should Be Visible    ${LISTS_HEADER}

Verify Header Title Is QuickList
    [Documentation]    Verifica se o título do header é QuickList
    Element Should Contain Text    ${LISTS_HEADER_TITLE}    QuickList

Verify Logout Button Is Displayed
    [Documentation]    Verifica se o botão de logout está visível
    Element Should Be Visible    ${LISTS_LOGOUT_BUTTON}

Verify FAB Is Displayed
    [Documentation]    Verifica se o FAB está visível
    Element Should Be Visible    ${LISTS_FAB}

Verify Empty State Is Displayed
    [Documentation]    Verifica se o estado vazio está exibido
    Wait Until Element Is Visible    ${LISTS_EMPTY_STATE}    ${TIMEOUT}
    Element Should Contain Text    ${LISTS_EMPTY_STATE}    ${MSG_EMPTY_LISTS}

Verify Empty State Is Not Displayed
    [Documentation]    Verifica se o estado vazio NÃO está exibido
    Element Should Not Be Visible    ${LISTS_EMPTY_STATE}

# ============================================
# Verificações de Listas
# ============================================

Verify List Count
    [Documentation]    Verifica quantidade de listas
    [Arguments]    ${expected_count}
    ${count}=    Get Element Count    ${LIST_CARD}
    Should Be Equal As Integers    ${count}    ${expected_count}

Verify List Exists With Name
    [Documentation]    Verifica se lista com nome específico existe
    [Arguments]    ${list_name}
    Page Should Contain Text    ${list_name}

Verify List Does Not Exist With Name
    [Documentation]    Verifica se lista com nome específico NÃO existe
    [Arguments]    ${list_name}
    Page Should Not Contain Text    ${list_name}

Get List Card By Name
    [Documentation]    Retorna o locator do card da lista pelo nome
    [Arguments]    ${list_name}
    ${locator}=    Set Variable    xpath://div[@data-testid="list-card" and .//p[contains(text(), "${list_name}")]]
    RETURN    ${locator}

Verify List Progress Text
    [Documentation]    Verifica texto de progresso da lista
    [Arguments]    ${list_name}    ${expected_progress}
    ${card}=    Get List Card By Name    ${list_name}
    Element Should Contain    ${card}    ${expected_progress}

# ============================================
# Ações - FAB e Modal de Criação
# ============================================

Click FAB To Create List
    [Documentation]    Clica no FAB para criar nova lista
    Click Element When Ready    ${LISTS_FAB}
    Wait For Modal To Open    ${LIST_FORM_MODAL}

Enter List Name
    [Documentation]    Insere nome da lista no formulário
    [Arguments]    ${list_name}
    Input Text When Ready    ${LIST_FORM_INPUT}    ${list_name}

Clear List Name Input
    [Documentation]    Limpa o campo de nome da lista
    Clear Element Text    ${LIST_FORM_INPUT}

Click Cancel On List Form
    [Documentation]    Clica em cancelar no formulário de lista
    Click Element When Ready    ${LIST_FORM_CANCEL}
    Wait For Modal To Close    ${LIST_FORM_MODAL}

Click Submit On List Form
    [Documentation]    Clica em submeter no formulário de lista
    Click Element When Ready    ${LIST_FORM_SUBMIT}
    Wait For Modal To Close    ${LIST_FORM_MODAL}

Verify Submit Button Is Disabled
    [Documentation]    Verifica se botão de submit está desabilitado
    Element Should Be Disabled    ${LIST_FORM_SUBMIT}

Verify Submit Button Is Enabled
    [Documentation]    Verifica se botão de submit está habilitado
    Element Should Be Enabled    ${LIST_FORM_SUBMIT}

# ============================================
# Ações - Editar Lista
# ============================================

Click Edit Button For List
    [Documentation]    Clica no botão de editar da lista
    [Arguments]    ${list_name}
    ${card}=    Get List Card By Name    ${list_name}
    Click Element When Ready    ${card}//button[@data-testid="list-card-edit"]
    Wait For Modal To Open    ${LIST_FORM_MODAL}

Edit List Name
    [Documentation]    Edita o nome da lista
    [Arguments]    ${new_name}
    Clear And Input Text    ${LIST_FORM_INPUT}    ${new_name}
    Click Submit On List Form

# ============================================
# Ações - Deletar Lista
# ============================================

Click Delete Button For List
    [Documentation]    Clica no botão de deletar da lista
    [Arguments]    ${list_name}
    ${card}=    Get List Card By Name    ${list_name}
    Click Element When Ready    ${card}//button[@data-testid="list-card-delete"]
    Wait For Modal To Open    ${DELETE_CONFIRM_MODAL}

Confirm Delete List
    [Documentation]    Confirma exclusão da lista
    Click Element When Ready    ${DELETE_CONFIRM_BUTTON}
    Wait For Modal To Close    ${DELETE_CONFIRM_MODAL}

Cancel Delete List
    [Documentation]    Cancela exclusão da lista
    Click Element When Ready    ${DELETE_CONFIRM_CANCEL}
    Wait For Modal To Close    ${DELETE_CONFIRM_MODAL}

Verify Delete Confirmation Message
    [Documentation]    Verifica mensagem de confirmação de exclusão
    [Arguments]    ${list_name}
    Element Should Contain    ${DELETE_CONFIRM_MESSAGE}    ${list_name}

# ============================================
# Ações - Navegação
# ============================================

Click On List To Open Details
    [Documentation]    Clica na lista para abrir detalhes
    [Arguments]    ${list_name}
    ${card}=    Get List Card By Name    ${list_name}
    Click Element When Ready    ${card}//p[@data-testid="list-card-name"]

Click Logout Button
    [Documentation]    Clica no botão de logout
    Click Element When Ready    ${LISTS_LOGOUT_BUTTON}

# ============================================
# Fluxos Completos
# ============================================

Create New List
    [Documentation]    Cria uma nova lista
    [Arguments]    ${list_name}
    Click FAB To Create List
    Enter List Name    ${list_name}
    Click Submit On List Form
    Verify List Exists With Name    ${list_name}

Delete List
    [Documentation]    Deleta uma lista
    [Arguments]    ${list_name}
    Click Delete Button For List    ${list_name}
    Confirm Delete List
    Verify List Does Not Exist With Name    ${list_name}

Edit List
    [Documentation]    Edita nome de uma lista
    [Arguments]    ${old_name}    ${new_name}
    Click Edit Button For List    ${old_name}
    Edit List Name    ${new_name}
    Verify List Exists With Name    ${new_name}
    Verify List Does Not Exist With Name    ${old_name}
