using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class GameWorld
{
    public delegate void OnUpdate(float deltaTime, int index);
    public event OnUpdate onUpdate;

    public event System.Action<float, int> onActionUpdate;

    public void Update(float deltaTime, int index)
    {
        onUpdate?.Invoke(deltaTime, index);

        onActionUpdate?.Invoke(deltaTime, index);
    }
}



public class GameInstance : MonoBehaviour
{
    private GameWorld m_GameWorld;

    // Start is called before the first frame update
    void Start()
    {
        m_GameWorld = new GameWorld();
        m_GameWorld.onUpdate += OnUpdate;
        m_GameWorld.onActionUpdate += OnActionUpdate;
    }

    // Update is called once per frame
    void Update()
    {
        m_GameWorld?.Update(Time.deltaTime, 1);
    }

    private void OnUpdate(float deltaTime, int index)
    {
        UnityEngine.Debug.Log($"deltaTime = {deltaTime}, index = {index}");
    }

    private void OnActionUpdate(float deltaTime, int index)
    {
        UnityEngine.Debug.Log($"deltaTime = {deltaTime}, index = {index}");
    }
}
