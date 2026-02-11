import { useState, useEffect, useRef } from 'react'
import ModalWrapper from './ModalWrapper'

export default function ListFormModal({ isOpen, onClose, onSave, editingList }) {
  const [nome, setNome] = useState('')
  const inputRef = useRef(null)

  useEffect(() => {
    setNome(editingList ? editingList.nome : '')
    if (isOpen && inputRef.current) {
      setTimeout(() => inputRef.current?.focus(), 100)
    }
  }, [isOpen, editingList])

  function handleSave() {
    const trimmed = nome.trim()
    if (!trimmed) return
    onSave(trimmed)
    onClose()
  }

  return (
    <ModalWrapper isOpen={isOpen} onClose={onClose} title={editingList ? 'Editar lista' : 'Nova lista'} testId="list-form-modal">
      <input
        ref={inputRef}
        data-testid="list-form-input"
        type="text"
        value={nome}
        onChange={(e) => setNome(e.target.value)}
        onKeyDown={(e) => e.key === 'Enter' && handleSave()}
        placeholder="Nome da lista"
        className="w-full border border-gray-300 rounded-xl px-4 py-3 text-base outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
      />
      <div className="flex gap-3 mt-4">
        <button data-testid="list-form-cancel" onClick={onClose} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-gray-600 text-sm font-medium">
          Cancelar
        </button>
        <button
          data-testid="list-form-submit"
          onClick={handleSave}
          disabled={!nome.trim()}
          className="flex-1 py-2.5 rounded-xl bg-blue-600 text-white text-sm font-semibold disabled:opacity-40"
        >
          {editingList ? 'Salvar' : 'Criar'}
        </button>
      </div>
    </ModalWrapper>
  )
}
