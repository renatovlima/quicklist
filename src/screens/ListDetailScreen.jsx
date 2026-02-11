import { useState, useRef } from 'react'
import Header from '../components/Header'
import ProgressBar from '../components/ProgressBar'
import SearchInput from '../components/SearchInput'
import ItemCard from '../components/ItemCard'
import ItemFormModal from '../components/modals/ItemFormModal'
import BuyModal from '../components/modals/BuyModal'
import PriceHistoryModal from '../components/modals/PriceHistoryModal'
import DeleteConfirmModal from '../components/modals/DeleteConfirmModal'
import CatalogModal from '../components/modals/CatalogModal'
import { useData } from '../context/DataContext'

export default function ListDetailScreen({ listId, onBack, onShoppingMode }) {
  const { getListById, getItemsByListId, addItem, updateItem, deleteItem, toggleItemStatus, addPriceRecord, addMarket } = useData()
  const list = getListById(listId)
  const allItems = getItemsByListId(listId)

  const [search, setSearch] = useState('')
  const [quickAdd, setQuickAdd] = useState('')
  const [editingItem, setEditingItem] = useState(null)
  const [itemFormOpen, setItemFormOpen] = useState(false)
  const [buyItem, setBuyItem] = useState(null)
  const [historyItem, setHistoryItem] = useState(null)
  const [deletingItem, setDeletingItem] = useState(null)
  const [catalogOpen, setCatalogOpen] = useState(false)
  const inputRef = useRef(null)

  const filteredItems = search.trim()
    ? allItems.filter((i) => i.nome.toLowerCase().includes(search.toLowerCase()))
    : allItems

  const bought = allItems.filter((i) => i.status === 'comprado').length

  function handleQuickAdd() {
    const trimmed = quickAdd.trim()
    if (!trimmed) return
    addItem(listId, trimmed)
    setQuickAdd('')
    inputRef.current?.focus()
  }

  function handleEditSave(nome) {
    if (editingItem) updateItem(editingItem.id, { nome })
  }

  function handleMarkBought(item, toBuy) {
    if (toBuy) {
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

  function handleCatalogAdd(nomes) {
    nomes.forEach((nome) => addItem(listId, nome))
  }

  if (!list) return null

  return (
    <div data-testid="list-detail-screen" className="min-h-screen bg-gray-50 flex flex-col">
      <Header
        title={list.nome}
        showBack
        onBack={onBack}
        rightContent={
          <button data-testid="shopping-mode-button" onClick={onShoppingMode} className="text-white bg-blue-700 hover:bg-blue-800 text-xs font-semibold px-3 py-1.5 rounded-lg">
            Modo Compra
          </button>
        }
      />

      <ProgressBar bought={bought} total={allItems.length} />

      {allItems.length > 2 && <SearchInput value={search} onChange={setSearch} />}

      {/* Campo de adicionar rápido */}
      <div className="px-4 py-3 bg-white border-b border-gray-200">
        <div className="flex gap-2">
          <input
            ref={inputRef}
            data-testid="quick-add-input"
            type="text"
            value={quickAdd}
            onChange={(e) => setQuickAdd(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleQuickAdd()}
            placeholder="Adicionar item..."
            className="flex-1 border border-gray-300 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
          />
          <button
            data-testid="quick-add-button"
            onClick={handleQuickAdd}
            disabled={!quickAdd.trim()}
            className="w-11 h-11 bg-blue-600 text-white rounded-xl flex items-center justify-center disabled:opacity-40 active:scale-90 transition-transform"
            aria-label="Adicionar"
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
              <line x1="12" y1="5" x2="12" y2="19" />
              <line x1="5" y1="12" x2="19" y2="12" />
            </svg>
          </button>
          <button
            data-testid="catalog-button"
            onClick={() => setCatalogOpen(true)}
            className="w-11 h-11 bg-gray-100 text-gray-600 rounded-xl flex items-center justify-center hover:bg-gray-200 active:scale-90 transition-transform"
            aria-label="Catálogo de itens"
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="3" width="7" height="7" rx="1" />
              <rect x="14" y="3" width="7" height="7" rx="1" />
              <rect x="3" y="14" width="7" height="7" rx="1" />
              <rect x="14" y="14" width="7" height="7" rx="1" />
            </svg>
          </button>
        </div>
      </div>

      {/* Lista de itens */}
      <main className="flex-1">
        {filteredItems.length === 0 ? (
          <div data-testid="items-empty-state" className="text-center py-12">
            <p className="text-gray-400 text-sm">
              {allItems.length === 0 ? 'Adicione itens usando o campo acima.' : 'Nenhum item encontrado.'}
            </p>
          </div>
        ) : (
          filteredItems.map((item) => (
            <ItemCard
              key={item.id}
              item={item}
              onMarkBought={handleMarkBought}
              onEdit={(i) => { setEditingItem(i); setItemFormOpen(true) }}
              onDelete={(i) => setDeletingItem(i)}
              onHistory={(i) => setHistoryItem(i)}
            />
          ))
        )}
      </main>

      {/* Modais */}
      <ItemFormModal
        isOpen={itemFormOpen}
        onClose={() => { setItemFormOpen(false); setEditingItem(null) }}
        editingItem={editingItem}
        onSave={handleEditSave}
      />
      <CatalogModal
        isOpen={catalogOpen}
        onClose={() => setCatalogOpen(false)}
        onAdd={handleCatalogAdd}
        existingItemNames={allItems.map((i) => i.nome)}
      />
      <BuyModal isOpen={!!buyItem} onClose={() => setBuyItem(null)} item={buyItem} onConfirm={handleBuyConfirm} />
      <PriceHistoryModal isOpen={!!historyItem} onClose={() => setHistoryItem(null)} item={historyItem} />
      <DeleteConfirmModal
        isOpen={!!deletingItem}
        onClose={() => setDeletingItem(null)}
        message={`Excluir "${deletingItem?.nome}"?`}
        onConfirm={() => { deleteItem(deletingItem.id); setDeletingItem(null) }}
      />
    </div>
  )
}
