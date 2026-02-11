import { createContext, useContext, useCallback } from 'react'
import { useLocalStorage } from '../hooks/useLocalStorage'

const AuthContext = createContext()

function decodeJwtPayload(token) {
  const base64Url = token.split('.')[1]
  const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
  return JSON.parse(atob(base64))
}

export function AuthProvider({ children }) {
  const [user, setUser] = useLocalStorage('ql_user', null)

  const handleCredentialResponse = useCallback((response) => {
    const payload = decodeJwtPayload(response.credential)
    setUser({
      id: payload.sub,
      nome: payload.name,
      email: payload.email,
      foto: payload.picture,
    })
  }, [setUser])

  function logout() {
    if (user?.email && window.google?.accounts?.id) {
      window.google.accounts.id.revoke(user.email, () => {})
    }
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, handleCredentialResponse, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  return useContext(AuthContext)
}
