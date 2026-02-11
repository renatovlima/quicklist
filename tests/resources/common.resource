*** Settings ***
Documentation     Keywords e configurações comuns para os testes do QuickList
Library           SeleniumLibrary
Library           Collections
Library           String
Library           DateTime
Resource          variables.resource

*** Keywords ***
# ============================================
# Setup e Teardown
# ============================================

Open Browser To QuickList
    [Documentation]    Abre o navegador na aplicação QuickList
    Open Browser    ${BASE_URL}    ${BROWSER}
    Set Window Size    375    812
    Set Selenium Implicit Wait    ${TIMEOUT}

Close Test Browser
    [Documentation]    Fecha o navegador e limpa dados
    Close All Browsers

Setup Test With Clean State
    [Documentation]    Configura teste com estado limpo (sem dados)
    Open Browser To QuickList
    Clear All Local Storage
    Reload Page

Setup Test With Authenticated User
    [Documentation]    Configura teste com usuário autenticado
    Open Browser To QuickList
    Clear All Local Storage
    Set Mock User In LocalStorage
    Reload Page
    Wait Until Page Contains Element    css:[data-testid="lists-screen"]    ${TIMEOUT}

Setup Test With Sample Data
    [Documentation]    Configura teste com dados de exemplo
    Open Browser To QuickList
    Clear All Local Storage
    Set Mock User In LocalStorage
    Set Sample Lists In LocalStorage
    Set Sample Items In LocalStorage
    Reload Page
    Wait Until Page Contains Element    css:[data-testid="lists-screen"]    ${TIMEOUT}

# ============================================
# LocalStorage Operations
# ============================================

Clear All Local Storage
    [Documentation]    Limpa todo o localStorage
    Execute Javascript    localStorage.clear();

Set Mock User In LocalStorage
    [Documentation]    Define usuário mock no localStorage
    ${user_json}=    Set Variable    {"id": "test-user-123", "name": "Usuário Teste", "email": "teste@example.com", "picture": ""}
    Execute Javascript    localStorage.setItem('${LS_USER}', '${user_json}');

Set Sample Lists In LocalStorage
    [Documentation]    Define listas de exemplo no localStorage
    ${lists_json}=    Set Variable    [{"id": "list-1", "nome": "Lista de Compras"}, {"id": "list-2", "nome": "Lista do Mês"}]
    Execute Javascript    localStorage.setItem('${LS_LISTS}', '${lists_json}');

Set Sample Items In LocalStorage
    [Documentation]    Define itens de exemplo no localStorage
    ${items_json}=    Set Variable    [{"id": "item-1", "list_id": "list-1", "nome": "Arroz", "status": "pendente"}, {"id": "item-2", "list_id": "list-1", "nome": "Feijão", "status": "comprado"}, {"id": "item-3", "list_id": "list-2", "nome": "Leite", "status": "pendente"}]
    Execute Javascript    localStorage.setItem('${LS_ITEMS}', '${items_json}');

Get Local Storage Value
    [Documentation]    Obtém valor do localStorage
    [Arguments]    ${key}
    ${value}=    Execute Javascript    return localStorage.getItem('${key}');
    RETURN    ${value}

Set Local Storage Value
    [Documentation]    Define valor no localStorage
    [Arguments]    ${key}    ${value}
    Execute Javascript    localStorage.setItem('${key}', '${value}');

Remove Local Storage Item
    [Documentation]    Remove item do localStorage
    [Arguments]    ${key}
    Execute Javascript    localStorage.removeItem('${key}');

# ============================================
# Waits e Verificações
# ============================================

Wait For Element To Be Visible
    [Documentation]    Espera elemento ficar visível
    [Arguments]    ${locator}    ${timeout}=${TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}

Wait For Element To Disappear
    [Documentation]    Espera elemento desaparecer
    [Arguments]    ${locator}    ${timeout}=${TIMEOUT}
    Wait Until Element Is Not Visible    ${locator}    ${timeout}

Wait For Page Load
    [Documentation]    Espera a página carregar completamente
    Wait For Condition    return document.readyState == "complete"    ${TIMEOUT}

Element Should Be Visible And Enabled
    [Documentation]    Verifica se elemento está visível e habilitado
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Element Should Be Enabled    ${locator}

Element Should Be Visible And Disabled
    [Documentation]    Verifica se elemento está visível mas desabilitado
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Element Should Be Disabled    ${locator}

# ============================================
# Interações com Elementos
# ============================================

Click Element When Ready
    [Documentation]    Clica em elemento quando estiver pronto
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Wait Until Element Is Enabled    ${locator}    ${TIMEOUT}
    Click Element    ${locator}

Input Text When Ready
    [Documentation]    Insere texto quando elemento estiver pronto
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Wait Until Element Is Enabled    ${locator}    ${TIMEOUT}
    Input Text    ${locator}    ${text}

Clear And Input Text
    [Documentation]    Limpa campo e insere novo texto
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

Press Enter Key
    [Documentation]    Pressiona tecla Enter
    [Arguments]    ${locator}
    Press Keys    ${locator}    ENTER

# ============================================
# Verificações de Conteúdo
# ============================================

Page Should Contain Text
    [Documentation]    Verifica se página contém texto
    [Arguments]    ${text}
    Wait Until Page Contains    ${text}    ${TIMEOUT}

Page Should Not Contain Text
    [Documentation]    Verifica se página não contém texto
    [Arguments]    ${text}
    Wait Until Page Does Not Contain    ${text}    ${TIMEOUT}

Element Text Should Be
    [Documentation]    Verifica texto do elemento
    [Arguments]    ${locator}    ${expected_text}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Element Text Should Be    ${locator}    ${expected_text}

Element Should Contain Text
    [Documentation]    Verifica se elemento contém texto
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Element Should Contain    ${locator}    ${text}

# ============================================
# Contadores e Listas
# ============================================

Get Element Count
    [Documentation]    Retorna quantidade de elementos
    [Arguments]    ${locator}
    ${count}=    Get Element Count    ${locator}
    RETURN    ${count}

Verify Element Count
    [Documentation]    Verifica quantidade de elementos
    [Arguments]    ${locator}    ${expected_count}
    ${count}=    Get Element Count    ${locator}
    Should Be Equal As Integers    ${count}    ${expected_count}

# ============================================
# Screenshots e Debug
# ============================================

Take Screenshot On Failure
    [Documentation]    Captura screenshot em caso de falha
    Capture Page Screenshot

Log Current URL
    [Documentation]    Registra URL atual
    ${url}=    Get Location
    Log    URL atual: ${url}

Log Page Source
    [Documentation]    Registra código fonte da página
    ${source}=    Get Source
    Log    ${source}

# ============================================
# Modais
# ============================================

Wait For Modal To Open
    [Documentation]    Espera modal abrir
    [Arguments]    ${modal_locator}=css:[data-testid="modal-wrapper"]
    Wait Until Element Is Visible    ${modal_locator}    ${TIMEOUT}

Wait For Modal To Close
    [Documentation]    Espera modal fechar
    [Arguments]    ${modal_locator}=css:[data-testid="modal-wrapper"]
    Wait Until Element Is Not Visible    ${modal_locator}    ${TIMEOUT}

Close Modal By Clicking Outside
    [Documentation]    Fecha modal clicando fora
    Click Element    css:[data-testid="modal-overlay"]
    Wait For Modal To Close

# ============================================
# Navegação
# ============================================

Navigate To Lists Screen
    [Documentation]    Navega para tela de listas
    Go To    ${LISTS_URL}
    Wait Until Page Contains Element    css:[data-testid="lists-screen"]    ${TIMEOUT}

Navigate To List Detail
    [Documentation]    Navega para detalhe da lista
    [Arguments]    ${list_id}
    Go To    ${LIST_DETAIL_URL}${list_id}
    Wait Until Page Contains Element    css:[data-testid="list-detail-screen"]    ${TIMEOUT}

Navigate To Shopping Mode
    [Documentation]    Navega para modo compra
    [Arguments]    ${list_id}
    Go To    ${SHOPPING_MODE_URL}${list_id}
    Wait Until Page Contains Element    css:[data-testid="shopping-mode-screen"]    ${TIMEOUT}

Click Back Button
    [Documentation]    Clica no botão voltar
    Click Element When Ready    css:[data-testid="back-button"]

Reload Page And Wait
    [Documentation]    Recarrega página e espera carregar
    Reload Page
    Wait For Page Load
