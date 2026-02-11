import { useData } from '../context/DataContext'

export default function ItemCard({ item, onMarkBought, onEdit, onDelete, onHistory }) {
  const { getLastPrice } = useData()
  const isBought = item.status === 'comprado'
  const lastPrice = getLastPrice(item.nome)

  return (
    <div data-testid="item-card" className={`flex items-start gap-3 px-4 py-3 border-b border-gray-100 bg-white ${isBought ? 'opacity-60' : ''}`}>
      {/* Checkbox */}
      <button
        data-testid="item-checkbox"
        onClick={() => {
          if (isBought) {
            onMarkBought(item, false)
          } else {
            onMarkBought(item, true)
          }
        }}
        className="mt-0.5 shrink-0"
        aria-label={isBought ? 'Desmarcar item' : 'Marcar como comprado'}
      >
        <div
          className={`w-6 h-6 rounded-full border-2 flex items-center justify-center transition-colors ${
            isBought ? 'bg-green-600 border-green-600' : 'border-gray-300 hover:border-blue-400'
          }`}
        >
          {isBought && (
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          )}
        </div>
      </button>

      {/* Conteúdo */}
      <div className="flex-1 min-w-0">
        <p data-testid="item-name" className={`text-base text-gray-800 ${isBought ? 'line-through' : ''}`}>{item.nome}</p>
        {lastPrice && (
          <span data-testid="item-price-badge" className="inline-block mt-0.5 text-xs bg-green-50 text-green-700 px-2 py-0.5 rounded-full">
            Último: R$ {lastPrice.preco.toFixed(2)} {lastPrice.mercado && `@ ${lastPrice.mercado}`}
          </span>
        )}
      </div>

      {/* Ações */}
      <div className="flex items-center gap-1 shrink-0">
        <button data-testid="item-history-button" onClick={() => onHistory(item)} className="text-gray-400 hover:text-blue-500 p-1.5" aria-label="Histórico de preços">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="12" cy="12" r="10" />
            <polyline points="12 6 12 12 16 14" />
          </svg>
        </button>
        <button data-testid="item-edit-button" onClick={() => onEdit(item)} className="text-gray-400 hover:text-amber-500 p-1.5" aria-label="Editar">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
          </svg>
        </button>
        <button data-testid="item-delete-button" onClick={() => onDelete(item)} className="text-gray-400 hover:text-red-500 p-1.5" aria-label="Excluir">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <polyline points="3 6 5 6 21 6" />
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
          </svg>
        </button>
      </div>
    </div>
  )
}
