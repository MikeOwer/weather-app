/**
 * Servicio especializado en autenticación
 * Maneja signup, login, logout y persistencia de sesión
 */

import { api } from './apiService';

const TOKEN_KEY = 'token';
const USER_KEY = 'user';

/**
 * Registra un nuevo usuario
 * @param {Object} userData - { name, email, password }
 * @returns {Promise<Object>} - { token, user }
 */
export const signup = async (userData) => {
  const response = await api.post('/auth/register', userData);
  
  // Guardar token y usuario en localStorage
  if (response.token) {
    localStorage.setItem(TOKEN_KEY, response.token);
    localStorage.setItem(USER_KEY, JSON.stringify(response.user));
  }
  
  return response;
};

/**
 * Inicia sesión
 * @param {Object} credentials - { email, password }
 * @returns {Promise<Object>} - { token, user }
 */
export const login = async (credentials) => {
  const response = await api.post('/auth/login', credentials);
  
  // Guardar token y usuario en localStorage
  if (response.token) {
    localStorage.setItem(TOKEN_KEY, response.token);
    localStorage.setItem(USER_KEY, JSON.stringify(response.user));
  }
  
  return response;
};

/**
 * Cierra sesión y limpia el almacenamiento local
 */
export const logout = () => {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(USER_KEY);
};

/**
 * Obtiene el token almacenado
 * @returns {string|null}
 */
export const getToken = () => {
  return localStorage.getItem(TOKEN_KEY);
};

/**
 * Obtiene los datos del usuario almacenado
 * @returns {Object|null}
 */
export const getStoredUser = () => {
  const user = localStorage.getItem(USER_KEY);
  return user ? JSON.parse(user) : null;
};

/**
 * Verifica si hay una sesión activa
 * @returns {boolean}
 */
export const isAuthenticated = () => {
  return !!getToken();
};

