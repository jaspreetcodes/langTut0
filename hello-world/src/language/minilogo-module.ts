import { MiniLogoServices } from './minilogo-module.js';
import { type Module, inject } from 'langium';
import { createDefaultModule, createDefaultSharedModule, type DefaultSharedModuleContext, type LangiumServices, type LangiumSharedServices, type PartialLangiumServices } from 'langium/lsp';
import { MiniLogoGeneratedModule, MiniLogoGeneratedSharedModule } from './generated/module.js';
import { MiniLogoValidator, registerValidationChecks } from './minilogo-validator.js';

/**
 * Declaration of custom services - add your own service classes here.
 */
export type MiniLogoAddedServices = {
    validation: {
        MiniLogoValidator: MiniLogoValidator
    }
}

/**
 * Union of Langium default services and your custom services - use this as constructor parameter
 * of custom service classes.
 */
export type MiniLogoServices = LangiumServices & MiniLogoAddedServices

/**
 * Dependency injection module that overrides Langium default services and contributes the
 * declared custom services. The Langium defaults can be partially specified to override only
 * selected services, while the custom services must be fully specified.
 */
export const MiniLogoModule: Module<MiniLogoServices, PartialLangiumServices & MiniLogoAddedServices> = {
    validation: {
        MiniLogoValidator: () => new MiniLogoValidator()
    }
};

/**
 * Create the full set of services required by Langium.
 *
 * First inject the shared services by merging two modules:
 *  - Langium default shared services
 *  - Services generated by langium-cli
 *
 * Then inject the language-specific services by merging three modules:
 *  - Langium default language-specific services
 *  - Services generated by langium-cli
 *  - Services specified in this file
 *
 * @param context Optional module context with the LSP connection
 * @returns An object wrapping the shared services and the language-specific services
 */
export function createMiniLogoServices(context: DefaultSharedModuleContext): {
    shared: LangiumSharedServices,
    MiniLogo: MiniLogoServices
} {
    const shared = inject(
        createDefaultSharedModule(context),
        MiniLogoGeneratedSharedModule
    );
    const MiniLogo = inject(
        createDefaultModule({ shared }),
        MiniLogoGeneratedModule,
        MiniLogoModule
    );
    shared.ServiceRegistry.register(MiniLogo);
    registerValidationChecks(MiniLogo);
    return { shared, MiniLogo };
}
