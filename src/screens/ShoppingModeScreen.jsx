import { useState, useMemo } from 'react'
import ProgressBar from '../components/ProgressBar'
import BuyModal from '../components/modals/BuyModal'
import { useData } from '../context/DataContext'

export default function ShoppingModeScreen({ listId, onBack }) {
  const { getListById, getItemsByListId, toggleItemStatus, addPriceRecord, addMarket } = useData()
  const list = getListById(listId)
  const items = getItemsByListId(listId)
  const [buyItem, setBuyItem] = useState(null)

  const { pending, bought } = useMemo(() => {
    const p = items.filter((i) => i.status === 'pendente')
    const b = items.filter((i) => i.status === 'comprado')
    return { pending: p, bought: b }
  }, [items])

  function handleTap(item) {
    if (item.status === 'pendente') {
      setBuyItem(item)
    } else {
      toggleItemStatus(item.id, null, null)
    }
  }

  function handleBuyConfirm(preco, mercado) {
    if (!buyItem) return
    toggleItemStatus(buyItem.id, preco, mercado)
    if (preco !== null) {
      addPriceRecord(buyItem.nome, preco, mercado)
      if (mercado) addMarket(mercado)
    }
    setBuyItem(null)
  }

  if (!list) return null

  return (
    <div data-testid="shopping-mode-screen" className="min-h-screen bg-gray-50 flex flex-col">
      {/* Header modo compra */}
      <header data-testid="header" className="bg-white shadow-sm sticky top-0 z-10">
        <div className="flex items-center px-4 py-3">
          <button data-testid="back-button" onClick={onBack} className="flex items-center text-blue-600 font-medium text-sm">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" className="mr-1">
              <path d="M15 18l-6-6 6-6" />
            </svg>
            Sair
          </button>
          <h1 data-testid="header-title" className="flex-1 text-center text-base font-semibold text-gray-800">Modo Compra</h1>
          <div className="w-16" />
        </div>
        <ProgressBar bought={bought.length} total={items.length} />
      </header>

      <main className="flex-1 pb-6">
        {/* Itens pendentes */}
        {pending.length > 0 && (
          <div data-testid="pending-section" className="px-4 pt-4 pb-2">
            <p data-testid="pending-section-title" className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Pendentes</p>
            <div data-testid="pending-items-list" className="flex flex-col gap-2">
              {pending.map((item) => (
                <button
                  key={item.id}
                  data-testid="shopping-item-pending"
                  onClick={() => handleTap(item)}
                  className="flex items-center gap-4 bg-white rounded-2xl shadow-sm border border-gray-100 px-5 py-4 w-full text-left active:scale-95 transition-transform"
                >
                  <div data-testid="shopping-item-checkbox" className="w-7 h-7 rounded-full border-2 border-gray-300 shrink-0 flex items-center justify-center" />
                  <span data-testid="shopping-item-name" className="text-lg text-gray-800 font-medium">{item.nome}</span>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Itens comprados */}
        {bought.length > 0 && (
          <div data-testid="bought-section" className="px-4 pt-4 pb-2">
            <p data-testid="bought-section-title" className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Comprados</p>
            <div data-testid="bought-items-list" className="flex flex-col gap-2">
              {bought.map((item) => (
                <button
                  key={item.id}
                  data-testid="shopping-item-bought"
                  onClick={() => handleTap(item)}
                  className="flex items-center gap-4 bg-white rounded-2xl shadow-sm border border-gray-100 px-5 py-4 w-full text-left opacity-50 active:scale-95 transition-transform"
                >
                  <div data-testid="shopping-item-checkbox" className="w-7 h-7 rounded-full bg-green-600 shrink-0 flex items-center justify-center">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                      <polyline points="20 6 9 17 4 12" />
                    </svg>
                  </div>
                  <span data-testid="shopping-item-name" className="text-lg text-gray-600 font-medium line-through">{item.nome}</span>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Estado vazio */}
        {items.length === 0 && (
          <div data-testid="shopping-empty-state" className="text-center py-16">
            <p className="text-gray-400 text-sm">A lista está vazia.</p>
          </div>
        )}
      </main>

      {/* Modal de compra */}
      <BuyModal isOpen={!!buyItem} onClose={() => setBuyItem(null)} item={buyItem} onConfirm={handleBuyConfirm} />
    </div>
  )
}
