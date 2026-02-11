export default function ProgressBar({ bought, total }) {
  const pct = total === 0 ? 0 : Math.round((bought / total) * 100)

  return (
    <div data-testid="progress-bar" className="px-4 py-3 bg-white border-b border-gray-200">
      <div className="flex justify-between items-center mb-1.5">
        <span className="text-sm font-medium text-gray-600">Progresso</span>
        <span data-testid="progress-text" className="text-sm font-semibold text-blue-600">
          {bought}/{total} {total === 1 ? 'item' : 'itens'} {bought === total && total > 0 ? '✓' : 'comprados'}
        </span>
      </div>
      <div className="w-full bg-gray-200 rounded-full h-2.5">
        <div
          data-testid="progress-fill"
          className="h-2.5 rounded-full transition-all duration-300"
          style={{
            width: `${pct}%`,
            backgroundColor: pct === 100 ? '#16a34a' : '#3b82f6',
          }}
        />
      </div>
    </div>
  )
}
