module TotallyRestfulAuthorization
  module PermissionDsl
    def self.included(base)
      base.class_eval do
      
        base.send :extend, ClassMethods
      
        private
      
        def self.view_permissions
          @@view_permissions ||= {self.name => {}}
          @@view_permissions[self.name] ||= {}
        end
      
        def self.create_permissions
          @@create_permissions ||= {self.name => {}}
          @@create_permissions[self.name] ||= {}
        end
      
        def self.update_permissions
          @@update_permissions ||= {self.name => {}}
          @@update_permissions[self.name] ||= {}
          @@update_permissions[self.name]
        end
      
        def self.destroy_permissions
          @@destroy_permissions ||= {self.name => {}}
          @@destroy_permissions[self.name] ||= {}
        end
      
      end
    end
  
    module ClassMethods
      def updatable_by(role, options = {})
        add_options update_permissions, role, options
      end
    
      def viewable_by(role, options = {})
        add_options view_permissions, role, options
      end
    
      def creatable_by(role, options = {})
        add_options create_permissions, role, options
      end
    
      def destroyable_by(role, options = {})
        add_options destroy_permissions, role, options
      end
    
      private
    
      def add_options(permissions, role, options)
        if role.is_a?(Array)
          role.each do |_role|
            add_options permissions, _role, options
          end
        else
          permissions[role] ||= []
          permissions[role] << options
        end
      end
    end
  
    def updatable_by?(user, field = nil)
      check_permissions self.class.update_permissions, user, field
    end
  
    def viewable_by?(user, field = nil)
      check_permissions self.class.view_permissions, user, field
    end
  
    def creatable_by?(user, field = nil)
      check_permissions self.class.create_permissions, user, field
    end
  
    def destroyable_by?(user, field = nil)
      check_permissions self.class.destroy_permissions, user, field
    end
  
    private
  
    def check_permissions(permissions, user, field)
      permissions.keys.inject(false) do |result, role|
        result || check_permission(permissions[role], role, user, field)
      end
    end
  
    def check_permission(permission, role, user, field)
      permission.inject(false) do |result, role_options|
        result || (user_has_permission(user, role) && field_in_only_list(field, role_options) &&
          !field_in_except_list(field, role_options) && condition_met(user, role_options))
      end
    end
  
    def user_has_permission(user, role)
      if role.is_a?(Hash)
        self.send(role[:associated]) == user
      elsif role == :self
        user == self
      elsif role == :anyone
        true
      else
        user && user.send("#{role}?")
      end
    end
  
    def field_in_only_list(field, options)
      if options[:only]
        options[:only].include?(field)
      else
        true
      end
    end
  
    def field_in_except_list(field, options)
      if options[:except]
        options[:except].include?(field)
      else
        false
      end
    end
  
    def condition_met(user, options)
      if options[:condition]
        options[:condition].call(self, user)
      else
        true
      end
    end
  end
end