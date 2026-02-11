import { useState, useRef, useEffect } from 'react'
import ModalWrapper from './ModalWrapper'
import { useData } from '../../context/DataContext'

export default function BuyModal({ isOpen, onClose, item, onConfirm }) {
  const [preco, setPreco] = useState('')
  const [mercado, setMercado] = useState('')
  const [showSuggestions, setShowSuggestions] = useState(false)
  const { markets } = useData()
  const mercadoRef = useRef(null)

  useEffect(() => {
    setPreco('')
    setMercado('')
  }, [isOpen])

  const filteredMarkets = mercado.trim()
    ? markets.filter((m) => m.toLowerCase().includes(mercado.toLowerCase()) && m.toLowerCase() !== mercado.toLowerCase())
    : markets

  function handleConfirm(withoutPrice = false) {
    if (withoutPrice) {
      onConfirm(null, null)
    } else {
      const p = preco.trim() ? parseFloat(preco) : null
      const m = mercado.trim() || null
      if (p !== null && isNaN(p)) return
      onConfirm(p, m)
    }
    onClose()
  }

  if (!item) return null

  return (
    <ModalWrapper isOpen={isOpen} onClose={onClose} title={`Marcar como comprado`} testId="buy-modal">
      <p className="text-sm text-gray-500 mb-3">
        <span data-testid="buy-modal-item-name" className="font-medium text-gray-700">{item.nome}</span> — informe o preço e o mercado (opcionais).
      </p>

      {/* Preço */}
      <label className="block mb-1 text-sm font-medium text-gray-600">Preço (R$)</label>
      <input
        data-testid="buy-modal-price-input"
        type="number"
        min="0"
        step="0.01"
        value={preco}
        onChange={(e) => setPreco(e.target.value)}
        placeholder="0,00"
        className="w-full border border-gray-300 rounded-xl px-4 py-2.5 text-base outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 mb-3"
      />

      {/* Mercado com autocomplete */}
      <label className="block mb-1 text-sm font-medium text-gray-600">Mercado</label>
      <div className="relative">
        <input
          ref={mercadoRef}
          data-testid="buy-modal-market-input"
          type="text"
          value={mercado}
          onChange={(e) => {
            setMercado(e.target.value)
            setShowSuggestions(true)
          }}
          onFocus={() => setShowSuggestions(true)}
          placeholder="Nome do mercado"
          className="w-full border border-gray-300 rounded-xl px-4 py-2.5 text-base outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
        />
        {showSuggestions && filteredMarkets.length > 0 && (
          <ul data-testid="market-suggestions" className="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-xl shadow-lg max-h-40 overflow-y-auto">
            {filteredMarkets.map((m) => (
              <li
                key={m}
                data-testid="market-suggestion-item"
                onMouseDown={() => {
                  setMercado(m)
                  setShowSuggestions(false)
                }}
                className="px-4 py-2.5 text-sm text-gray-700 hover:bg-blue-50 cursor-pointer"
              >
                {m}
              </li>
            ))}
          </ul>
        )}
      </div>

      {/* Botões */}
      <div className="flex flex-col gap-2 mt-4">
        <button
          data-testid="buy-modal-confirm"
          onClick={() => handleConfirm(false)}
          className="w-full py-2.5 rounded-xl bg-blue-600 text-white text-sm font-semibold"
        >
          Confirmar compra
        </button>
        <button
          data-testid="buy-modal-confirm-no-price"
          onClick={() => handleConfirm(true)}
          className="w-full py-2.5 rounded-xl border border-gray-200 text-gray-600 text-sm font-medium"
        >
          Confirmar sem preço
        </button>
      </div>
    </ModalWrapper>
  )
}
