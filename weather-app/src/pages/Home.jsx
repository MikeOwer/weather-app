/**
 * Página Home - Vista protegida
 */

import './Home.css';

export const Home = () => {
  return (
    <div className="home">
      <div className="home-hero">
        <h1 className="home-title">Bienvenido a Weather App</h1>
        <p className="home-description">
          Has iniciado sesión correctamente. Tu sesión está protegida y se mantiene activa.
        </p>
      </div>
      
      <div className="home-cards">
        <div className="home-card">
          <div className="home-card-icon">🔒</div>
          <h3 className="home-card-title">Sesión Protegida</h3>
          <p className="home-card-text">
            Tu token de autenticación se guarda de forma segura en localStorage.
          </p>
        </div>
        
        <div className="home-card">
          <div className="home-card-icon">🌐</div>
          <h3 className="home-card-title">Estado Global</h3>
          <p className="home-card-text">
            Usamos React Context para manejar el estado de autenticación sin prop drilling.
          </p>
        </div>
        
        <div className="home-card">
          <div className="home-card-icon">⚡</div>
          <h3 className="home-card-title">Arquitectura Escalable</h3>
          <p className="home-card-text">
            Servicios separados, componentes reutilizables y código limpio listo para crecer.
          </p>
        </div>
      </div>
    </div>
  );
};

