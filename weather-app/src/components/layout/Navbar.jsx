/**
 * Componente Navbar
 * Muestra el nombre del usuario autenticado y botón de logout
 */

import { useAuth } from '../../hooks/useAuth';
import { Button } from '../common/Button';
import './Navbar.css';

export const Navbar = () => {
  const { user, logout } = useAuth();

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <div className="navbar-brand">
          <h2 className="navbar-logo">Weather App</h2>
        </div>
        
        <div className="navbar-user">
          <div className="navbar-user-info">
            <span className="navbar-user-avatar">
              {user?.name?.charAt(0).toUpperCase()}
            </span>
            <div className="navbar-user-details">
              <span className="navbar-user-name">{user?.name}</span>
              <span className="navbar-user-email">{user?.email}</span>
            </div>
          </div>
          
          <Button 
            variant="outline" 
            onClick={logout}
            className="navbar-logout-btn"
          >
            Cerrar Sesión
          </Button>
        </div>
      </div>
    </nav>
  );
};

