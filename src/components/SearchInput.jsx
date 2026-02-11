export default function SearchInput({ value, onChange, placeholder = 'Buscar itens...' }) {
  return (
    <div className="px-4 pt-3 pb-2 bg-white">
      <div className="flex items-center bg-gray-100 rounded-xl px-3 py-2">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="mr-2 shrink-0">
          <circle cx="11" cy="11" r="8" />
          <line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
        <input
          data-testid="search-input"
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          className="bg-transparent text-gray-800 text-sm outline-none w-full placeholder-gray-400"
        />
        {value && (
          <button data-testid="search-clear" onClick={() => onChange('')} className="text-gray-400 hover:text-gray-600 ml-2">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        )}
      </div>
    </div>
  )
}
