import ModalWrapper from './ModalWrapper'
import { useData } from '../../context/DataContext'

function formatDate(iso) {
  return new Date(iso).toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

export default function PriceHistoryModal({ isOpen, onClose, item }) {
  const { getPriceHistoryForItem, getBestPrice } = useData()
  if (!item) return null

  const history = getPriceHistoryForItem(item.nome)
  const bestPrice = getBestPrice(item.nome)

  return (
    <ModalWrapper isOpen={isOpen} onClose={onClose} title="Histórico de preços" testId="price-history-modal">
      <p className="text-sm text-gray-500 mb-3">
        <span data-testid="price-history-item-name" className="font-medium text-gray-700">{item.nome}</span>
      </p>

      {history.length === 0 ? (
        <p data-testid="price-history-empty" className="text-sm text-gray-400 text-center py-4">Nenhum preço registrado ainda.</p>
      ) : (
        <>
          {/* Melhor preço */}
          {bestPrice && (
            <div data-testid="price-history-best" className="bg-green-50 border border-green-200 rounded-xl px-4 py-3 mb-3 flex items-center gap-2">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#16a34a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
              </svg>
              <div>
                <p className="text-xs text-green-700 font-semibold">Melhor preço</p>
                <p className="text-sm text-green-800 font-medium">
                  R$ {bestPrice.preco.toFixed(2)}{bestPrice.mercado && ` @ ${bestPrice.mercado}`}
                </p>
              </div>
            </div>
          )}

          {/* Lista de registros */}
          <div data-testid="price-history-list" className="divide-y divide-gray-100">
            {history.map((record) => (
              <div key={record.id} data-testid="price-history-entry" className="flex justify-between items-center py-2.5">
                <div>
                  <p className="text-sm text-gray-800 font-medium">R$ {record.preco.toFixed(2)}</p>
                  {record.mercado && <p className="text-xs text-gray-500">{record.mercado}</p>}
                </div>
                <p className="text-xs text-gray-400">{formatDate(record.data_compra)}</p>
              </div>
            ))}
          </div>
        </>
      )}
    </ModalWrapper>
  )
}
