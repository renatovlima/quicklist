import { useEffect, useRef } from 'react'
import { useAuth } from '../context/AuthContext'

const GOOGLE_CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID

function loadGsiScript() {
  return new Promise((resolve) => {
    if (window.google?.accounts?.id) {
      resolve()
      return
    }
    const script = document.createElement('script')
    script.src = 'https://accounts.google.com/gsi/client'
    script.async = true
    script.onload = resolve
    document.head.appendChild(script)
  })
}

export default function LoginScreen() {
  const { handleCredentialResponse } = useAuth()
  const buttonRef = useRef(null)

  useEffect(() => {
    if (!GOOGLE_CLIENT_ID) return

    loadGsiScript().then(() => {
      window.google.accounts.id.initialize({
        client_id: GOOGLE_CLIENT_ID,
        callback: handleCredentialResponse,
      })

      if (buttonRef.current) {
        window.google.accounts.id.renderButton(buttonRef.current, {
          theme: 'outline',
          size: 'large',
          width: buttonRef.current.offsetWidth,
          logo_alignment: 'center',
        })
      }

      window.google.accounts.id.prompt()
    })
  }, [handleCredentialResponse])

  return (
    <div data-testid="login-screen" className="min-h-screen bg-gradient-to-b from-blue-600 to-blue-800 flex flex-col items-center justify-center px-6">
      {/* Logo / Icon */}
      <div className="mb-6" data-testid="login-logo">
        <div className="w-20 h-20 bg-white rounded-3xl flex items-center justify-center shadow-lg">
          <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#2563eb" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
            <line x1="3" y1="6" x2="21" y2="6" />
            <path d="M16 10a4 4 0 0 1-8 0" />
          </svg>
        </div>
      </div>

      {/* Título */}
      <h1 data-testid="login-title" className="text-4xl font-bold text-white mb-2 tracking-tight">QuickList</h1>
      <p data-testid="login-subtitle" className="text-blue-200 text-center text-sm mb-10 max-w-xs">
        Organize suas compras de forma rápida e inteligente. Registre preços e acompanhe o progresso.
      </p>

      {/* Botão Google Sign In */}
      <div className="w-full max-w-xs">
        {GOOGLE_CLIENT_ID ? (
          <div ref={buttonRef} id="google-signin-button" data-testid="google-login-button" className="flex justify-center" />
        ) : (
          <div data-testid="login-error" className="bg-red-50 border border-red-200 rounded-xl px-4 py-3 text-center">
            <p className="text-red-600 text-sm font-medium">Configuração incompleta</p>
            <p className="text-red-500 text-xs mt-1">
              Defina <code className="bg-red-100 px-1 rounded">VITE_GOOGLE_CLIENT_ID</code> no arquivo <code className="bg-red-100 px-1 rounded">.env</code>
            </p>
          </div>
        )}
      </div>
    </div>
  )
}
