import { useState, useMemo, useEffect } from 'react'
import { CATALOG } from '../../data/catalog'
import { normalizeText } from '../../utils/normalize'

export default function CatalogModal({ isOpen, onClose, onAdd, existingItemNames }) {
  const [category, setCategory] = useState('todos')
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState([])
  const [customItem, setCustomItem] = useState('')

  useEffect(() => {
    if (isOpen) {
      setSelected([])
      setSearch('')
      setCategory('todos')
    }
  }, [isOpen])

  const existingNormalized = useMemo(
    () => new Set(existingItemNames.map(normalizeText)),
    [existingItemNames]
  )

  const displayItems = useMemo(() => {
    const cats = category === 'todos' ? CATALOG : CATALOG.filter((c) => c.id === category)
    let result = []
    for (const cat of cats) {
      for (const item of cat.itens) {
        result.push(item)
      }
    }
    if (search.trim()) {
      const q = normalizeText(search)
      result = result.filter((nome) => normalizeText(nome).includes(q))
    }
    return result
  }, [category, search])

  function isSelected(nome) {
    return selected.includes(nome)
  }

  function isAlreadyInList(nome) {
    return existingNormalized.has(normalizeText(nome))
  }

  function toggleItem(nome) {
    if (isAlreadyInList(nome)) return
    setSelected((prev) =>
      prev.includes(nome) ? prev.filter((n) => n !== nome) : [...prev, nome]
    )
  }

  function handleAddCustom() {
    const trimmed = customItem.trim()
    if (!trimmed) return
    onAdd([trimmed])
    setCustomItem('')
  }

  function handleAddSelected() {
    if (selected.length === 0) return
    onAdd([...selected])
    setSelected([])
    onClose()
  }

  if (!isOpen) return null

  return (
    <div data-testid="catalog-modal" className="absolute inset-0 z-50 bg-white flex flex-col">
      {/* Header */}
      <header className="flex items-center justify-between px-4 py-3 border-b border-gray-200 bg-white">
        <button data-testid="catalog-close" onClick={onClose} className="text-gray-500 hover:text-gray-700 p-1">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
            <line x1="18" y1="6" x2="6" y2="18" />
            <line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        </button>
        <h2 className="text-base font-semibold text-gray-800">Catálogo</h2>
        <div className="w-8" />
      </header>

      {/* Busca */}
      <div className="px-4 pt-3 pb-2 bg-white">
        <div className="flex items-center bg-gray-100 rounded-xl px-3 py-2">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="mr-2 shrink-0">
            <circle cx="11" cy="11" r="8" />
            <line x1="21" y1="21" x2="16.65" y2="16.65" />
          </svg>
          <input
            data-testid="catalog-search"
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Buscar no catálogo..."
            className="bg-transparent text-gray-800 text-sm outline-none w-full placeholder-gray-400"
          />
          {search && (
            <button onClick={() => setSearch('')} className="text-gray-400 hover:text-gray-600 ml-2">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
                <line x1="18" y1="6" x2="6" y2="18" />
                <line x1="6" y1="6" x2="18" y2="18" />
              </svg>
            </button>
          )}
        </div>
      </div>

      {/* Tabs de categoria */}
      <div data-testid="catalog-tabs" className="flex flex-wrap gap-2 px-4 pb-3">
        {[{ id: 'todos', nome: 'Todos' }, ...CATALOG].map((cat) => (
          <button
            key={cat.id}
            data-testid="catalog-tab"
            onClick={() => setCategory(cat.id)}
            className={`text-xs font-semibold px-3 py-1.5 rounded-full transition-colors ${
              category === cat.id
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {cat.nome}
          </button>
        ))}
      </div>

      {/* Grid de itens */}
      <div data-testid="catalog-items-grid" className="flex-1 overflow-y-auto px-4 pb-28">
        {displayItems.length === 0 ? (
          <p className="text-gray-400 text-sm text-center py-8">Nenhum item encontrado.</p>
        ) : (
          <div className="grid grid-cols-2 gap-2">
            {displayItems.map((nome) => {
              const inList = isAlreadyInList(nome)
              const sel = isSelected(nome)
              return (
                <button
                  key={nome}
                  data-testid="catalog-item"
                  onClick={() => toggleItem(nome)}
                  disabled={inList}
                  className={`text-left px-3 py-2.5 rounded-xl border text-sm font-medium transition-colors ${
                    inList
                      ? 'bg-gray-50 border-gray-200 text-gray-400 cursor-not-allowed'
                      : sel
                        ? 'bg-blue-600 border-blue-600 text-white'
                        : 'bg-white border-gray-200 text-gray-700 hover:border-blue-300'
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <span className="truncate">{nome}</span>
                    {inList && (
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                    )}
                  </div>
                </button>
              )
            })}
          </div>
        )}
      </div>

      {/* Barra inferior: item customizado + botão adicionar */}
      <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-3">
        <div className="flex gap-2 mb-3">
          <input
            data-testid="catalog-custom-input"
            type="text"
            value={customItem}
            onChange={(e) => setCustomItem(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleAddCustom()}
            placeholder="Criar novo item..."
            className="flex-1 border border-gray-300 rounded-xl px-3 py-2 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
          />
          <button
            onClick={handleAddCustom}
            disabled={!customItem.trim()}
            className="w-10 h-10 bg-gray-100 text-gray-600 rounded-xl flex items-center justify-center disabled:opacity-40 hover:bg-gray-200 active:scale-90 transition-transform"
            aria-label="Criar item"
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
              <line x1="12" y1="5" x2="12" y2="19" />
              <line x1="5" y1="12" x2="19" y2="12" />
            </svg>
          </button>
        </div>
        <button
          data-testid="catalog-add-button"
          onClick={handleAddSelected}
          disabled={selected.length === 0}
          className="w-full py-2.5 rounded-xl bg-blue-600 text-white text-sm font-semibold disabled:opacity-40"
        >
          {selected.length === 0
            ? 'Selecione itens acima'
            : `Adicionar ${selected.length} ${selected.length === 1 ? 'item' : 'itens'}`}
        </button>
      </div>
    </div>
  )
}
