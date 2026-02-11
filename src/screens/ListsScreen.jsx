import { useState } from 'react'
import Header from '../components/Header'
import ListFormModal from '../components/modals/ListFormModal'
import DeleteConfirmModal from '../components/modals/DeleteConfirmModal'
import { useData } from '../context/DataContext'

export default function ListsScreen({ onSelectList }) {
  const { lists, createList, updateList, deleteList, getItemsByListId } = useData()
  const [listFormOpen, setListFormOpen] = useState(false)
  const [editingList, setEditingList] = useState(null)
  const [deletingList, setDeletingList] = useState(null)

  function handleSave(nome) {
    if (editingList) {
      updateList(editingList.id, nome)
    } else {
      createList(nome)
    }
    setEditingList(null)
  }

  return (
    <div data-testid="lists-screen" className="min-h-screen bg-gray-50 flex flex-col">
      <Header title="QuickList" showLogout />

      <main className="flex-1 px-4 py-4">
        {lists.length === 0 ? (
          <div data-testid="empty-state" className="text-center py-16">
            <div className="text-gray-300 mb-3">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" className="mx-auto">
                <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
                <line x1="3" y1="6" x2="21" y2="6" />
                <path d="M16 10a4 4 0 0 1-8 0" />
              </svg>
            </div>
            <p className="text-gray-500 text-sm">Nenhuma lista ainda.</p>
            <p className="text-gray-400 text-xs mt-1">Toque no + para criar sua primeira lista.</p>
          </div>
        ) : (
          <div className="flex flex-col gap-3">
            {lists.map((list) => {
              const items = getItemsByListId(list.id)
              const bought = items.filter((i) => i.status === 'comprado').length
              return (
                <div key={list.id} data-testid="list-card" className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                  <button onClick={() => onSelectList(list.id)} className="w-full text-left px-4 py-4">
                    <p data-testid="list-card-name" className="font-semibold text-gray-800">{list.nome}</p>
                    <p data-testid="list-card-progress" className="text-xs text-gray-400 mt-0.5">
                      {items.length === 0
                        ? 'Vazio'
                        : `${bought}/${items.length} itens comprados`}
                    </p>
                  </button>
                  <div className="flex border-t border-gray-100">
                    <button
                      data-testid="list-card-edit"
                      onClick={() => { setEditingList(list); setListFormOpen(true) }}
                      className="flex-1 py-2 text-gray-400 hover:text-amber-500 flex items-center justify-center"
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                      </svg>
                    </button>
                    <button
                      data-testid="list-card-delete"
                      onClick={() => setDeletingList(list)}
                      className="flex-1 py-2 text-gray-400 hover:text-red-500 flex items-center justify-center"
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <polyline points="3 6 5 6 21 6" />
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                      </svg>
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
        )}
      </main>

      {/* FAB — Botão + flutuante */}
      <button
        data-testid="fab-add-list"
        onClick={() => { setEditingList(null); setListFormOpen(true) }}
        className="absolute bottom-6 right-6 w-14 h-14 bg-blue-600 text-white rounded-full shadow-lg flex items-center justify-center hover:bg-blue-700 active:scale-90 transition-transform"
        aria-label="Criar nova lista"
      >
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
          <line x1="12" y1="5" x2="12" y2="19" />
          <line x1="5" y1="12" x2="19" y2="12" />
        </svg>
      </button>

      {/* Modais */}
      <ListFormModal isOpen={listFormOpen} onClose={() => setListFormOpen(false)} editingList={editingList} onSave={handleSave} />
      <DeleteConfirmModal
        isOpen={!!deletingList}
        onClose={() => setDeletingList(null)}
        message={`Excluir "${deletingList?.nome}" e todos os seus itens?`}
        onConfirm={() => { deleteList(deletingList.id); setDeletingList(null) }}
      />
    </div>
  )
}
