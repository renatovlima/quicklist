*** Settings ***
Documentation     Variáveis globais para os testes do QuickList

*** Variables ***
# URLs
${BASE_URL}                 http://localhost:5173
${LOGIN_URL}                ${BASE_URL}/
${LISTS_URL}                ${BASE_URL}/lists
${LIST_DETAIL_URL}          ${BASE_URL}/list/
${SHOPPING_MODE_URL}        ${BASE_URL}/shopping/

# Timeouts
${TIMEOUT}                  10s
${SHORT_TIMEOUT}            3s
${LONG_TIMEOUT}             30s

# Browser
${BROWSER}                  chrome
${HEADLESS}                 ${FALSE}

# LocalStorage Keys
${LS_USER}                  ql_user
${LS_LISTS}                 ql_lists
${LS_ITEMS}                 ql_items
${LS_PRICE_HISTORY}         ql_price_history
${LS_MARKETS}               ql_markets

# Test Data - Lists
${TEST_LIST_NAME}           Lista de Teste
${TEST_LIST_NAME_EDITED}    Lista Editada
${TEST_LIST_NAME_2}         Segunda Lista

# Test Data - Items
${TEST_ITEM_NAME}           Arroz
${TEST_ITEM_NAME_EDITED}    Arroz Integral
${TEST_ITEM_NAME_2}         Feijão
${TEST_ITEM_NAME_3}         Macarrão

# Test Data - Prices
${TEST_PRICE}               12.99
${TEST_PRICE_2}             15.50
${TEST_MARKET}              Supermercado Central
${TEST_MARKET_2}            Mercado do Bairro

# Categories
@{CATALOG_CATEGORIES}       Todos    Frutas    Laticínios    Carnes    Padaria    Bebidas    Condimentos    Limpeza    Outros

# Messages
${MSG_EMPTY_LISTS}          Nenhuma lista ainda.
${MSG_EMPTY_ITEMS}          Adicione itens usando o campo acima.
${MSG_PROGRESS_EMPTY}       Vazio
