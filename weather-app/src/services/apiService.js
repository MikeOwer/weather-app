/**
 * Servicio HTTP general para todas las peticiones API
 * Centraliza la configuración del cliente HTTP y manejo de errores
 */

const API_BASE_URL = 'http://localhost:3000';

/**
 * Realiza una petición HTTP genérica
 * @param {string} endpoint - Ruta del endpoint (ej: '/auth/login')
 * @param {Object} options - Opciones de fetch
 * @returns {Promise<Object>} - Respuesta parseada
 */
export const apiRequest = async (endpoint, options = {}) => {
  const url = `${API_BASE_URL}${endpoint}`;
  
  const config = {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  };

  // Si existe token en localStorage, agregarlo automáticamente
  const token = localStorage.getItem('token');
  if (token) {
    config.headers['Authorization'] = `Bearer ${token}`;
  }

  try {
    const response = await fetch(url, config);
    
    // Extraer el body antes de verificar el status
    const data = await response.json();

    if (!response.ok) {
      // Lanzar error con mensaje del servidor o mensaje genérico
      throw new Error(data.message || `Error ${response.status}: ${response.statusText}`);
    }

    return data;
  } catch (error) {
    // Si es un error de red o parsing
    if (error.name === 'TypeError' || error.message.includes('Failed to fetch')) {
      throw new Error('Error de conexión. Verifica que el servidor esté activo.');
    }
    
    // Re-lanzar el error para que lo maneje el caller
    throw error;
  }
};

/**
 * Métodos HTTP convenience
 */
export const api = {
  get: (endpoint, options = {}) => 
    apiRequest(endpoint, { ...options, method: 'GET' }),
  
  post: (endpoint, data, options = {}) => 
    apiRequest(endpoint, {
      ...options,
      method: 'POST',
      body: JSON.stringify(data),
    }),
  
  put: (endpoint, data, options = {}) => 
    apiRequest(endpoint, {
      ...options,
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  
  delete: (endpoint, options = {}) => 
    apiRequest(endpoint, { ...options, method: 'DELETE' }),
};

