defmodule GraphqlServerDemoWeb.Schema.Subscriptions.UserTest do

  use GraphqlServerDemoWeb.SubscriptionCase

  alias GraphqlServerDemo.Accounts

  defp setup_user _context do
    {:ok, user} = Accounts.create_user(%{
      name: "great name",
      email: "email@email.com",
      preferences: %{likes_emails: true, likes_phone_calls: true}
    })

    {:ok, %{user: user}}
  end

  @create_user_doc"""
    mutation createUser(
      $name: String,
      $email: String,
      $likesEmails: Boolean,
      $likesPhoneCalls: Boolean
    ) {
      createUser(
        name: $name,
        email: $email,
        preferences: {
          likesEmails: $likesEmails,
          likesPhoneCalls: $likesPhoneCalls
          }
      ) {
        id
        name
        email
      }
    }
  """

  @created_user_sub_doc"""
    subscription createdUser {
      createdUser {
        id
        name
        email
      }
    }
  """

  describe "@createdUser" do
    test "sends the user when the user_created mutation is triggered", %{socket: socket} do
      ref = push_doc socket, @created_user_sub_doc

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref = push_doc socket, @create_user_doc, variables: %{
        "name" => "great name",
        "email" => "email@email.com"
      }

      assert_reply ref, :ok, reply

      assert %{
        data: %{
          "createUser" => %{
            "id" => user_id,
            "name" => "great name",
            "email" => "email@email.com",
          }
        }
      } = reply

      assert_push "subscription:data", data

      assert %{
        result: %{
          data: %{
            "createdUser" => %{
              "id" => ^user_id,
              "name" => "great name",
              "email" => "email@email.com",
            }
          }
        },
        subscriptionId: ^subscription_id,
      } = data
    end
  end

  @update_user_preferences_doc"""
    mutation updateUserPreferences(
      $userId: ID,
      $likesEmails: Boolean,
      $likesPhoneCalls: Boolean
    ) {
    updateUserPreferences(
      userId: $userId,
      likesEmails: $likesEmails,
      likesPhoneCalls: $likesPhoneCalls
      ) {
        id
        likesEmails
        likesPhoneCalls
      }
    }
  """

  @updated_user_preferences_sub_doc"""
    subscription updatedUserPreferences($userId: ID){
      updatedUserPreferences(userId: $userId) {
        id
        likesEmails
      }
    }
  """

  describe "@userPreferencesUpdated" do
    setup [:setup_user]
    test "sends the user preferences when the @updatedUserPreferences mutation is triggered", %{socket: socket, user: user} do
      preferences_id = to_string(user.preferences.id)

      ref = push_doc socket, @updated_user_preferences_sub_doc, variables: %{userId: user.id}

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref = push_doc socket, @update_user_preferences_doc, variables: %{
        "userId" => user.id,
        "likesEmails" => false
      }

      assert_reply ref, :ok, reply

      assert %{
        data: %{
          "updateUserPreferences" => %{
            "id" => ^preferences_id,
            "likesEmails" => false,
            "likesPhoneCalls" => true
          }
        }
      } = reply

      assert_push "subscription:data", data

      assert %{
        result: %{
          data: %{
            "updatedUserPreferences" => %{
              "id" => ^preferences_id,
              "likesEmails" => false
            }
          }
        },
        subscriptionId: ^subscription_id,
      } = data
    end
  end
end
