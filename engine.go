/*
 * IBM Confidential
 * OCO Source Materials
 * IBM Concerto - Blockchain Solution Framework
 * Copyright IBM Corp. 2016
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 */

package main

import (
	"errors"
	"fmt"

	"github.com/robertkrimen/otto"
)

// Engine is a Go wrapper around an instance of the Engine JavaScript class.
type Engine struct {
	This *otto.Object
}

// EngineCallback is a structure used for callbacks from the chaincode.
type EngineCallback struct {
	Result []byte
	Error  error
}

// NewEngine creates a Go wrapper around a new instance of the Engine JavaScript class.
func NewEngine(vm *otto.Otto, container *Container) (result *Engine) {
	logger.Debug("Entering NewEngine", vm, container)
	defer func() { logger.Debug("Exiting NewEngine", result) }()

	// Create a new instance of the JavaScript chaincode class.
	temp, err := vm.Call("new concerto.Engine", nil, container.This)
	if err != nil {
		panic(fmt.Sprintf("Failed to create new instance of Engine JavaScript class: %v", err))
	} else if !temp.IsObject() {
		panic("New instance of Engine JavaScript class is not an object")
	}
	object := temp.Object()

	// Add a pointer to the Go object into the JavaScript object.
	result = &Engine{This: object}
	err = object.Set("$this", result)
	if err != nil {
		panic(fmt.Sprintf("Failed to store Go object in Engine JavaScript object: %v", err))
	}
	return result

}

// HandleCallback handles the execution of a JavaScript callback by the chaincode.
func (engine *Engine) handleCallback(channel chan EngineCallback, call otto.FunctionCall) (result otto.Value) {
	logger.Debug("Entering Engine.handleCallback", channel, call)
	defer func() { logger.Debug("Exiting Engine.handleCallback", result) }()

	// Extract the error and data arguments from the callback.
	jsError := call.Argument(0)
	jsData := call.Argument(1)

	// If the error exists, pass it back to our channel.
	if jsError.IsObject() {
		jsString, err := jsError.ToString()
		if err != nil {
			channel <- EngineCallback{
				Result: nil,
				Error:  fmt.Errorf("Failed to convert JavaScript error into string: %v", err),
			}
		} else {
			channel <- EngineCallback{
				Result: nil,
				Error:  errors.New(jsString),
			}
		}
	} else if jsData.IsObject() {
		jsObject := jsData.Object()
		jsString, err := call.Otto.Call("JSON.stringify", nil, jsObject)
		if err != nil {
			channel <- EngineCallback{
				Result: nil,
				Error:  fmt.Errorf("Failed to serialize JavaScript data as JSON string: %v", err),
			}
		} else if !jsString.IsString() {
			channel <- EngineCallback{
				Result: nil,
				Error:  fmt.Errorf("Failed to serialize JavaScript data as JSON string"),
			}
		} else {
			channel <- EngineCallback{
				Result: []byte(jsString.String()),
				Error:  nil,
			}
		}
	} else {
		channel <- EngineCallback{
			Result: nil,
			Error:  nil,
		}
	}

	// No return value from the callback.
	return otto.UndefinedValue()

}

// Init executes the Engine.init(context, function, arguments, callback) JavaScript function.
func (engine *Engine) Init(context *Context, function string, arguments []string) (channel chan EngineCallback) {
	logger.Debug("Entering Engine.Init", context, function, arguments)
	defer func() { logger.Debug("Exiting Engine.Init", channel) }()

	// Create a channel to receieve the response from JavaScript.
	channel = make(chan EngineCallback, 1)

	// Call the JavaScript code and pass in a callback function.
	_, err := engine.This.Call("_init", context.This, function, arguments, func(call otto.FunctionCall) otto.Value {
		return engine.handleCallback(channel, call)
	})

	// Check for an error being thrown from JavaScript.
	if err != nil {
		channel <- EngineCallback{
			Result: nil,
			Error:  err,
		}
	}
	return channel

}

// Invoke executes the Engine.query(context, function, arguments, callback) JavaScript function.
func (engine *Engine) Invoke(context *Context, function string, arguments []string) (channel chan EngineCallback) {
	logger.Debug("Entering Engine.Invoke", context, function, arguments)
	defer func() { logger.Debug("Exiting Engine.Invoke", channel) }()

	// Create a channel to receieve the response from JavaScript.
	channel = make(chan EngineCallback, 1)

	// Call the JavaScript code and pass in a callback function.
	_, err := engine.This.Call("_invoke", context.This, function, arguments, func(call otto.FunctionCall) otto.Value {
		return engine.handleCallback(channel, call)
	})

	// Check for an error being thrown from JavaScript.
	if err != nil {
		channel <- EngineCallback{
			Result: nil,
			Error:  err,
		}
	}
	return channel

}

// Query executes the Engine.query(context, function, arguments, callback) JavaScript function.
func (engine *Engine) Query(context *Context, function string, arguments []string) (channel chan EngineCallback) {
	logger.Debug("Entering Engine.Query", context, function, arguments)
	defer func() { logger.Debug("Exiting Engine.Query", channel) }()

	// Create a channel to receieve the response from JavaScript.
	channel = make(chan EngineCallback, 1)

	// Call the JavaScript code and pass in a callback function.
	_, err := engine.This.Call("_query", context.This, function, arguments, func(call otto.FunctionCall) otto.Value {
		return engine.handleCallback(channel, call)
	})

	// Check for an error being thrown from JavaScript.
	if err != nil {
		channel <- EngineCallback{
			Result: nil,
			Error:  err,
		}
	}
	return channel

}
