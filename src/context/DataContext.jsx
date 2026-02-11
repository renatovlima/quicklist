import { createContext, useContext, useCallback } from 'react'
import { useLocalStorage } from '../hooks/useLocalStorage'
import { normalizeText } from '../utils/normalize'

const DataContext = createContext()

function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2)
}

function now() {
  return new Date().toISOString()
}

export function DataProvider({ children }) {
  const [lists, setLists] = useLocalStorage('ql_lists', [])
  const [items, setItems] = useLocalStorage('ql_items', [])
  const [priceHistory, setPriceHistory] = useLocalStorage('ql_price_history', [])
  const [markets, setMarkets] = useLocalStorage('ql_markets', [])

  // ── Listas ──────────────────────────────────
  const createList = useCallback((nome) => {
    const list = { id: generateId(), nome, created_at: now(), updated_at: now() }
    setLists((prev) => [...prev, list])
    return list
  }, [setLists])

  const updateList = useCallback((id, nome) => {
    setLists((prev) =>
      prev.map((l) => (l.id === id ? { ...l, nome, updated_at: now() } : l))
    )
  }, [setLists])

  const deleteList = useCallback((id) => {
    setLists((prev) => prev.filter((l) => l.id !== id))
    setItems((prev) => prev.filter((i) => i.list_id !== id))
  }, [setLists, setItems])

  const getListById = useCallback((id) => lists.find((l) => l.id === id), [lists])

  // ── Itens ───────────────────────────────────
  const addItem = useCallback((listId, nome) => {
    const item = {
      id: generateId(),
      list_id: listId,
      nome,
      status: 'pendente',
      preco_atual: null,
      mercado_atual: null,
      data_compra: null,
      created_at: now(),
      updated_at: now(),
    }
    setItems((prev) => [...prev, item])
    return item
  }, [setItems])

  const updateItem = useCallback((id, updates) => {
    setItems((prev) =>
      prev.map((i) => (i.id === id ? { ...i, ...updates, updated_at: now() } : i))
    )
  }, [setItems])

  const deleteItem = useCallback((id) => {
    setItems((prev) => prev.filter((i) => i.id !== id))
  }, [setItems])

  const getItemsByListId = useCallback(
    (listId) => items.filter((i) => i.list_id === listId),
    [items]
  )

  const toggleItemStatus = useCallback((id, preco, mercado) => {
    setItems((prev) =>
      prev.map((i) => {
        if (i.id !== id) return i
        if (i.status === 'pendente') {
          return {
            ...i,
            status: 'comprado',
            preco_atual: preco ?? null,
            mercado_atual: mercado ?? null,
            data_compra: now(),
            updated_at: now(),
          }
        }
        return { ...i, status: 'pendente', preco_atual: null, mercado_atual: null, data_compra: null, updated_at: now() }
      })
    )
  }, [setItems])

  // ── Histórico de Preços ─────────────────────
  const addPriceRecord = useCallback((itemNome, preco, mercado) => {
    const record = {
      id: generateId(),
      item_nome_normalizado: normalizeText(itemNome),
      preco,
      mercado,
      data_compra: now(),
    }
    setPriceHistory((prev) => [...prev, record])
  }, [setPriceHistory])

  const getPriceHistoryForItem = useCallback((itemNome) => {
    const key = normalizeText(itemNome)
    return priceHistory
      .filter((r) => r.item_nome_normalizado === key)
      .sort((a, b) => new Date(b.data_compra) - new Date(a.data_compra))
  }, [priceHistory])

  const getLastPrice = useCallback((itemNome) => {
    const history = getPriceHistoryForItem(itemNome)
    return history.length > 0 ? history[0] : null
  }, [getPriceHistoryForItem])

  const getBestPrice = useCallback((itemNome) => {
    const history = getPriceHistoryForItem(itemNome)
    if (history.length === 0) return null
    return history.reduce((best, r) => (r.preco < best.preco ? r : best), history[0])
  }, [getPriceHistoryForItem])

  // ── Mercados (autocomplete) ─────────────────
  const addMarket = useCallback((nome) => {
    if (!nome) return
    setMarkets((prev) => (prev.includes(nome) ? prev : [...prev, nome]))
  }, [setMarkets])

  return (
    <DataContext.Provider
      value={{
        lists,
        createList,
        updateList,
        deleteList,
        getListById,
        addItem,
        updateItem,
        deleteItem,
        getItemsByListId,
        toggleItemStatus,
        addPriceRecord,
        getPriceHistoryForItem,
        getLastPrice,
        getBestPrice,
        addMarket,
        markets,
      }}
    >
      {children}
    </DataContext.Provider>
  )
}

export function useData() {
  return useContext(DataContext)
}
