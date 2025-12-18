/**
 * Componente de Loading para pantallas completas
 */

import './Loading.css';

export const Loading = ({ message = 'Cargando...' }) => {
  return (
    <div className="loading-container">
      <div className="loading-spinner"></div>
      <p className="loading-message">{message}</p>
    </div>
  );
};

