import { useState, useEffect } from 'react'
import { BrowserRouter as Router, Routes, Route } from "react-router-dom"
import Login from './routes/Login'
import Home from './routes/Home'
import UserProfile from './routes/UserProfile'
import EmailReset from './routes/EmailReset'
import EmailVerification from './routes/EmailVerification'
import './App.css'
import Header from './components/Header';
import Signup from './routes/Signup'
import ResetPassword from './routes/ResetPassword'
import SignupMessage from './routes/SignupMessage'
import UserContext from './contexts/UserContext'

function App() {

  const [isMobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [userToken, setUserToken] = useState(null)

  console.log(userToken, "State of userToken in App")
  
  useEffect( () => {
    const token = localStorage.getItem("token")
    if(token) {
      setUserToken(token)
    }

  }, [])

  const handleToken = (token) => {
    localStorage.setItem("token", token)
    setUserToken(token)
  }

  const handleToggleMobileMenu = () => {
    setMobileMenuOpen(!isMobileMenuOpen);
  };


  return (
    <div>

    <UserContext.Provider value={{userToken}}>
    <Header />

    <Router>
     <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/login" element={<Login handleToken={handleToken} />} />
      <Route path="/signup" element={<Signup />} />
      <Route path="/profile" element={<UserProfile userToken={userToken} />} />
      <Route path="/email-reset" element={<EmailReset />} />
      <Route path="/email-verification" element={<EmailVerification />} />
      <Route path="/reset-password/:reset_token" element={<ResetPassword />} />
      <Route path="/signup-message" element={<SignupMessage />} />
     </Routes>
     </Router>
     </UserContext.Provider>
     </div>
  )
}

export default App
