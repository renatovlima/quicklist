import { useAuth } from '../context/AuthContext'

export default function Header({ title, showBack, onBack, rightContent }) {
  const { logout } = useAuth()

  return (
    <header data-testid="header" className="flex items-center justify-between bg-blue-600 text-white px-4 py-3 shadow-md sticky top-0 z-10">
      <div className="flex items-center gap-2 min-w-0">
        {showBack && (
          <button data-testid="back-button" onClick={onBack} className="text-white p-1 -ml-1" aria-label="Voltar">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M15 18l-6-6 6-6" />
            </svg>
          </button>
        )}
        <h1 data-testid="header-title" className="text-lg font-semibold truncate">{title}</h1>
      </div>
      <div className="flex items-center gap-2">
        {rightContent}
        {!showBack && (
          <button data-testid="logout-button" onClick={logout} className="text-white opacity-80 hover:opacity-100 p-1" aria-label="Logout">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
              <polyline points="16 17 21 12 16 7" />
              <line x1="21" y1="12" x2="9" y2="12" />
            </svg>
          </button>
        )}
      </div>
    </header>
  )
}
