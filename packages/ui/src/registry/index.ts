export {
  registerProduct,
  getProduct,
  getAllProducts,
  getProductsWithCapability,
  getProductsForWorkspace,
  loadProductsForWorkspace,
  ProductLauncher,
} from './ProductRegistry';
export type { ProductRegistration } from './ProductRegistry';

export { registerNavItems, getNavTree, getWorkspaceNavTree } from './NavigationRegistry';
export type { NavItem } from './NavigationRegistry';
