/**
 * Layout principal con Navbar
 */

import { Navbar } from './Navbar';
import './Layout.css';

export const Layout = ({ children }) => {
  return (
    <div className="layout">
      <Navbar />
      <main className="layout-content">
        {children}
      </main>
    </div>
  );
};

