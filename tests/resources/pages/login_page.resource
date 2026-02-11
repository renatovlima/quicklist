*** Settings ***
Documentation     Page Object para LoginScreen
Resource          ../common.resource

*** Variables ***
# Locators
${LOGIN_SCREEN}                 css:[data-testid="login-screen"]
${LOGIN_LOGO}                   css:[data-testid="login-logo"]
${LOGIN_TITLE}                  css:[data-testid="login-title"]
${LOGIN_SUBTITLE}               css:[data-testid="login-subtitle"]
${LOGIN_GOOGLE_BUTTON}          css:[data-testid="google-login-button"]
${LOGIN_ERROR_MESSAGE}          css:[data-testid="login-error"]
${GOOGLE_SIGN_IN_DIV}           id:google-signin-button

*** Keywords ***
# ============================================
# Verificações de Elementos
# ============================================

Verify Login Screen Is Displayed
    [Documentation]    Verifica se a tela de login está exibida
    Wait Until Element Is Visible    ${LOGIN_SCREEN}    ${TIMEOUT}
    Element Should Be Visible    ${LOGIN_LOGO}
    Element Should Be Visible    ${LOGIN_TITLE}

Verify Login Title
    [Documentation]    Verifica o título do login
    Element Should Contain Text    ${LOGIN_TITLE}    QuickList

Verify Login Subtitle Is Displayed
    [Documentation]    Verifica se o subtítulo está exibido
    Element Should Be Visible    ${LOGIN_SUBTITLE}

Verify Google Sign In Button Is Displayed
    [Documentation]    Verifica se o botão de login do Google está presente
    Wait Until Element Is Visible    ${GOOGLE_SIGN_IN_DIV}    ${TIMEOUT}

Verify Login Error Is Displayed
    [Documentation]    Verifica se mensagem de erro está exibida
    Wait Until Element Is Visible    ${LOGIN_ERROR_MESSAGE}    ${TIMEOUT}

# ============================================
# Ações
# ============================================

Click Google Sign In Button
    [Documentation]    Clica no botão de login do Google
    Click Element When Ready    ${GOOGLE_SIGN_IN_DIV}

Simulate Successful Google Login
    [Documentation]    Simula login bem sucedido do Google (para testes)
    Set Mock User In LocalStorage
    Reload Page

# ============================================
# Fluxos Completos
# ============================================

Login With Mock User
    [Documentation]    Realiza login com usuário mock
    Verify Login Screen Is Displayed
    Simulate Successful Google Login
    Wait Until Element Is Not Visible    ${LOGIN_SCREEN}    ${TIMEOUT}

Verify Redirect To Lists After Login
    [Documentation]    Verifica redirecionamento para listas após login
    Wait Until Page Contains Element    css:[data-testid="lists-screen"]    ${TIMEOUT}
