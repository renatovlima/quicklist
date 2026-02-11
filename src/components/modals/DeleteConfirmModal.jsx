import ModalWrapper from './ModalWrapper'

export default function DeleteConfirmModal({ isOpen, onClose, onConfirm, message = 'Esta ação não pode ser desfeit a.' }) {
  return (
    <ModalWrapper isOpen={isOpen} onClose={onClose} title="Confirmar exclusão" testId="delete-confirm-modal">
      <p data-testid="delete-confirm-message" className="text-gray-600 text-sm">{message}</p>
      <div className="flex gap-3 mt-4">
        <button data-testid="delete-confirm-cancel" onClick={onClose} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-gray-600 text-sm font-medium">
          Cancelar
        </button>
        <button data-testid="delete-confirm-button" onClick={onConfirm} className="flex-1 py-2.5 rounded-xl bg-red-500 text-white text-sm font-semibold">
          Excluir
        </button>
      </div>
    </ModalWrapper>
  )
}
