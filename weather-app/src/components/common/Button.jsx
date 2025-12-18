/**
 * Componente reutilizable de Button
 */

import './Button.css';

export const Button = ({ 
  children, 
  variant = 'primary', 
  loading = false,
  disabled = false,
  className = '',
  ...props 
}) => {
  return (
    <button
      className={`btn btn-${variant} ${className}`}
      disabled={disabled || loading}
      {...props}
    >
      {loading ? (
        <span className="btn-loading">
          <span className="spinner"></span>
          Cargando...
        </span>
      ) : (
        children
      )}
    </button>
  );
};

