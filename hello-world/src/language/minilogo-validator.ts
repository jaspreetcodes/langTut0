import type { ValidationAcceptor, ValidationChecks } from 'langium';
import type { Def, HelloWorldAstType, Model } from './generated/ast.js';
import type { MiniLogoServices } from './minilogo-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: MiniLogoServices) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.MiniLogoValidator;
    const checks: ValidationChecks<HelloWorldAstType> = {
        Model: validator.checkModel,
        Def: validator.checkDefs
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class HelloWorldValidator {

    checkModel(model: Model, accept: ValidationAcceptor): void {
        const previousNames = new Set<string>();
        const defs = model.defs;
        for (const def of defs) {
            if (previousNames.has(def.name.toLowerCase())) {
                accept('error', 'Duplicate definition: Definitions cannot re-define an existing definition name.', { node: def, property: 'name' });
            }
            else {
                previousNames.add(def.name.toLowerCase());
            }
        }
        // if (person.name) {
        //     const firstChar = person.name.substring(0, 1);
        //     if (firstChar.toUpperCase() !== firstChar) {
        //         accept('warning', 'Person name should start with a capital.', { node: person, property: 'name' });
        //     }
        // }
    }

    checkDefs(def: Def, accept: ValidationAcceptor): void {
        const previousNames = new Set<string>();
        const params = def.params;
        for (const param of params) {
            if (previousNames.has(param.name.toLowerCase())) {
                accept('error', 'Duplicate parameter name.', { node: param, property: 'name' });
            }
            else {
                previousNames.add(param.name.toLowerCase());
            }
        }
        // if (person.name) {
        //     const firstChar = person.name.substring(0, 1);
        //     if (firstChar.toUpperCase() !== firstChar) {
        //         accept('warning', 'Person name should start with a capital.', { node: person, property: 'name' });
        //     }
        // }
    }
}
