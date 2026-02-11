import { useState } from 'react'
import { AuthProvider, useAuth } from './context/AuthContext'
import { DataProvider } from './context/DataContext'
import LoginScreen from './screens/LoginScreen'
import ListsScreen from './screens/ListsScreen'
import ListDetailScreen from './screens/ListDetailScreen'
import ShoppingModeScreen from './screens/ShoppingModeScreen'

function AppRoutes() {
  const { user } = useAuth()
  const [screen, setScreen] = useState('lists')
  const [selectedListId, setSelectedListId] = useState(null)

  if (!user) return <LoginScreen />

  switch (screen) {
    case 'shopping-mode':
      return (
        <ShoppingModeScreen
          listId={selectedListId}
          onBack={() => setScreen('list-detail')}
        />
      )
    case 'list-detail':
      return (
        <ListDetailScreen
          listId={selectedListId}
          onBack={() => { setScreen('lists'); setSelectedListId(null) }}
          onShoppingMode={() => setScreen('shopping-mode')}
        />
      )
    default:
      return (
        <ListsScreen
          onSelectList={(id) => { setSelectedListId(id); setScreen('list-detail') }}
        />
      )
  }
}

export default function App() {
  return (
    <AuthProvider>
      <DataProvider>
        <div className="min-h-screen bg-slate-200 flex justify-center">
          <div className="w-full sm:max-w-md min-h-screen sm:shadow-2xl relative">
            <AppRoutes />
          </div>
        </div>
      </DataProvider>
    </AuthProvider>
  )
}
