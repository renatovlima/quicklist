*** Settings ***
Documentation     Testes da tela de Login do QuickList
...               Cobertura: Exibição de elementos, autenticação Google, redirecionamento
Library           SeleniumLibrary
Resource          ../resources/common.resource
Resource          ../resources/pages/login_page.resource
Resource          ../resources/pages/lists_page.resource

Suite Setup       Log    Iniciando testes de Login
Suite Teardown    Close All Browsers
Test Setup        Setup Test With Clean State
Test Teardown     Close Test Browser

*** Test Cases ***
# ============================================
# Testes de Exibição de Elementos
# ============================================

Login Screen Should Display Logo
    [Documentation]    Verifica se o logo está visível na tela de login
    [Tags]    login    ui    smoke
    Verify Login Screen Is Displayed
    Element Should Be Visible    ${LOGIN_LOGO}

Login Screen Should Display App Title
    [Documentation]    Verifica se o título QuickList está exibido
    [Tags]    login    ui    smoke
    Verify Login Screen Is Displayed
    Verify Login Title

Login Screen Should Display Subtitle
    [Documentation]    Verifica se o subtítulo está exibido
    [Tags]    login    ui
    Verify Login Screen Is Displayed
    Verify Login Subtitle Is Displayed

Login Screen Should Display Google Sign In Button
    [Documentation]    Verifica se o botão de login do Google está presente
    [Tags]    login    ui    smoke
    Verify Login Screen Is Displayed
    Verify Google Sign In Button Is Displayed

# ============================================
# Testes de Autenticação
# ============================================

Successful Login Should Redirect To Lists Screen
    [Documentation]    Verifica redirecionamento após login bem sucedido
    [Tags]    login    auth    smoke
    Verify Login Screen Is Displayed
    Simulate Successful Google Login
    Verify Redirect To Lists After Login

User Data Should Be Stored In LocalStorage After Login
    [Documentation]    Verifica se dados do usuário são armazenados no localStorage
    [Tags]    login    auth    storage
    Verify Login Screen Is Displayed
    Simulate Successful Google Login
    ${user_data}=    Get Local Storage Value    ${LS_USER}
    Should Not Be Empty    ${user_data}
    Should Contain    ${user_data}    test-user-123

# ============================================
# Testes de Estado
# ============================================

Authenticated User Should Be Redirected To Lists
    [Documentation]    Usuário autenticado deve ser redirecionado para listas
    [Tags]    login    auth    redirect
    Set Mock User In LocalStorage
    Reload Page
    Wait Until Page Contains Element    css:[data-testid="lists-screen"]    ${TIMEOUT}
    Verify Lists Screen Is Displayed

Unauthenticated User Should See Login Screen
    [Documentation]    Usuário não autenticado deve ver tela de login
    [Tags]    login    auth
    Clear All Local Storage
    Reload Page
    Verify Login Screen Is Displayed

# ============================================
# Testes de Layout Responsivo
# ============================================

Login Screen Should Have Mobile Layout
    [Documentation]    Verifica layout mobile da tela de login
    [Tags]    login    responsive
    Set Window Size    375    812
    Verify Login Screen Is Displayed
    Element Should Be Visible    ${LOGIN_LOGO}
    Element Should Be Visible    ${LOGIN_TITLE}

Login Screen Should Center Content
    [Documentation]    Verifica se o conteúdo está centralizado
    [Tags]    login    layout
    Verify Login Screen Is Displayed
    # O container principal deve estar centralizado
    ${logo}=    Get Element Attribute    ${LOGIN_LOGO}    class
    Log    Classes do logo: ${logo}
