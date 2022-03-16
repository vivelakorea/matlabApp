classdef todolist < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        createButton        matlab.ui.control.Button
        todoEditField       matlab.ui.control.EditField
        todoEditFieldLabel  matlab.ui.control.Label
    end

    % let's add some more properties...
    properties (Access = public)
        todoBtns            cell
    end
    
    
    methods (Access = private)
        
        function newBtn = createNewBtn(app, val, id)
            newBtn = uibutton(app.UIFigure, ...
                "Text", val, ...
                "Position", [50 + 110*fix(id/7), ...
                             100 + 50*mod(id, 7), ... 
                             100, 30]);
            
            
        end
        
        function deleteBtn(~, event)
            delete(event.Source)
        end
        
    end
    
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.todoBtns = {};
        end

        % Callback function: createButton, todoEditField
        function createButtonPushed(app, event)
            if size(app.todoBtns, 2) < 35
                val = app.todoEditField.Value;
                app.todoEditField.Value = "";
                newBtn = createNewBtn(app, val, size(app.todoBtns, 2));
                newBtn.ButtonPushedFcn = createCallbackFcn(app, @deleteBtn, true);
                if size(app.todoBtns, 2) == 0
                    app.todoBtns{1} = newBtn;
                else
                    app.todoBtns{end+1} = newBtn;
                end
            else
                app.todoEditField.Value = "To many things to do";
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create todoEditFieldLabel
            app.todoEditFieldLabel = uilabel(app.UIFigure);
            app.todoEditFieldLabel.HorizontalAlignment = 'right';
            app.todoEditFieldLabel.Position = [164 70 30 22];
            app.todoEditFieldLabel.Text = 'todo';

            % Create todoEditField
            app.todoEditField = uieditfield(app.UIFigure, 'text');
            app.todoEditField.ValueChangedFcn = createCallbackFcn(app, @createButtonPushed, true);
            app.todoEditField.Position = [209 70 100 22];

            % Create createButton
            app.createButton = uibutton(app.UIFigure, 'push');
            app.createButton.ButtonPushedFcn = createCallbackFcn(app, @createButtonPushed, true);
            app.createButton.Position = [377 70 100 22];
            app.createButton.Text = 'create';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = todolist

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end